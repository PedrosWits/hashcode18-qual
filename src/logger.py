import os
import logging as lg

logs_folder = "logs"

def get_logger(name, log2console = False, path = logs_folder):

    logger = lg.getLogger(name)
    logger.setLevel(lg.DEBUG)

    logFormatter = lg.Formatter("%(asctime)s [%(name)-12.12s] [%(levelname)-5.5s]  %(message)s")

    if not logger.hasHandlers():
        if log2console:
            consoleHandler = lg.StreamHandler()
            consoleHandler.setFormatter(logFormatter)
            consoleHandler.setLevel(lg.INFO)
            logger.addHandler(consoleHandler)

        filename = "{}.log".format(name)
        filepath = os.path.join(path, filename)

        fileHandler = lg.FileHandler(filepath)
        fileHandler.setFormatter(logFormatter)
        fileHandler.setLevel(lg.DEBUG)

        logger.addHandler(fileHandler)

    return logger
