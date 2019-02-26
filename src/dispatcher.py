import numpy as np
import pandas as pd

from logger import get_logger

logger = get_logger('dispatcher')

def go(params, rides):
    R, C, F, N, B, T = params

    vehicles = pd.DataFrame({'id' : np.arange(F),
                             'row' : np.zeros(F),
                             'column' : np.zeros(F),
                             'state' : np.zeros(F)})

    rides = rides.assign(vehicle = 0,
                          dt = lambda x: x.t_f - x.t_s,
                          d = lambda x: abs(x.row_f - x.row_s) + abs(x.col_f - x.col_s))

    rides = rides.assign(t_margin = lambda x: abs(x.dt - x.d))
    rides = rides.assign(latest_s = lambda x: x.t_s + x.t_margin)

    rides = rides.sort_values('t_s')

    chosen_vehicles = []

    for ride in rides.iterrows():
        attr = ride[1]

        # sort vehicles by
        vehicles = vehicles.assign(d2ride = lambda x: abs(x.row - attr['row_s']) + abs(x.column - attr['col_s']))
        vehicles = vehicles.assign(t_min_start = lambda x: x.state + x.d2ride)
        vehicles = vehicles.assign(t_s = attr['t_s'])

        vehicles = vehicles.assign(t_init = np.amax(vehicles[['t_min_start', 't_s']], axis = 1))

        empty_vehicles = vehicles.loc[vehicles['t_init'] + attr['d'] <= attr['t_f']]

        empty_vehicles = empty_vehicles.sort_values('d2ride')

        if len(empty_vehicles) == 0:
            chosen_vehicles.append((-1,0))
            logger.warning('Failed to assign a vehicle to ride {} (ts = {}, tf = {})'\
                            .format(ride[0], attr['t_s'], attr['t_f']))
            continue

        empty_vehicles = empty_vehicles.reset_index(drop = True)

        chosen_vehicle = empty_vehicles.loc[0, 'id']

        vehicle = vehicles.loc[vehicles['id'] == chosen_vehicle].to_dict()
        chosen_vehicles.append((chosen_vehicle,vehicle['t_init'][chosen_vehicle] == attr['t_s']))

        vehicles.loc[vehicles['id'] == chosen_vehicle, 'state'] = vehicle['t_init'][chosen_vehicle] + attr['d']
        vehicles.loc[vehicles['id'] == chosen_vehicle, 'row'] = attr['row_f']
        vehicles.loc[vehicles['id'] == chosen_vehicle, 'column'] = attr['col_f']

        logger.info('Assigning vehicle {} ({}, {}) to ride {} (ts = {}, tf = {}, start = ({}, {}), finish = ({}, {}))'\
                    .format(chosen_vehicle, vehicle['row'][chosen_vehicle], vehicle['column'][chosen_vehicle], ride[0], attr['t_s'], attr['t_f'], attr['row_s'], attr['col_s'], attr['row_f'], attr['col_f']))


    return rides.assign(vehicle = list(map(lambda x: x[0], chosen_vehicles)),
                        bonus   = list(map(lambda x: x[1], chosen_vehicles)))
