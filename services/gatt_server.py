#https://github.com/gitdefllo/lighthouse-weather-station/tree/master/station/ble_gatt_server
#Use this to obtain predefined methods for the advertisment, service, and charateristic

import dbus

from ble_gatt_server.advertisment import Advertisment
from ble_gatt_server.service import Applications, Service, Characteristic, Descriptor

GATT_CHRC_IFACE = ""
NOTIFY_TIMEOUT = 5000

class BleApplication(Application):
    pass

class IoTDeviceAdvertisment(Advertisment):
    def __init__(self, index):
        Advertisment.__init__(self, index, "peripheral")
        self.add_local_name("GLWAIoTBLE")
        self.include_tx_power = True

class IoTDeviceService(Service):
    GLWA_SVC_UUID = "" #Generate a unique UUID

    def __init__(self, index):
        Service.__init__(self, index, self.GLWA_SVC_UUID, True)
        self.add_characterisitc() #Create and input characteristic