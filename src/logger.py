import os
import logging as lg

logs_folder = "."

def get_logger(name, path = logs_folder):

    logger = lg.getLogger(name)
    logger.setLevel(lg.DEBUG)

    logFormatter = lg.Formatter("%(asctime)s [%(name)-12.12s] [%(levelname)-5.5s]  %(message)s")

    if not logger.hasHandlers():
        consoleHandler = lg.StreamHandler()
        consoleHandler.setFormatter(logFormatter)
        consoleHandler.setLevel(lg.INFO)

        filename = "{}.log".format(name)
        filepath = os.path.join(path, filename)

        fileHandler = lg.FileHandler(filepath)
        fileHandler.setFormatter(logFormatter)
        fileHandler.setLevel(lg.DEBUG)

        logger.addHandler(consoleHandler)
        logger.addHandler(fileHandler)

    return logger
