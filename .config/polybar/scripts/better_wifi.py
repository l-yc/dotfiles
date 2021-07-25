#!/bin/python3

import dbus

NM = 'org.freedesktop.NetworkManager'
NMCA = NM + '.Connection.Active'
NMDW = NM + '.Device.Wireless'
NMAP = NM + '.AccessPoint'
DBUS_PROPS = 'org.freedesktop.DBus.Properties'

def main():
    bus = dbus.SystemBus()
    nm = bus.get_object(NM, '/org/freedesktop/NetworkManager')
    conns = nm.Get(NM, 'ActiveConnections', dbus_interface=DBUS_PROPS)
    conn = conns[0]
    active_conn = bus.get_object(NM, conn)

    devices = active_conn.Get(NMCA, 'Devices', dbus_interface=DBUS_PROPS)
    dev_name = devices[0]
    dev = bus.get_object(NM, dev_name)
    print(dev)

    ap_name = dev.Get(NMDW, 'ActiveAccessPoint', dbus_interface=DBUS_PROPS)
    ap = bus.get_object(NM, ap_name)
    ssid = ap.Get(NMAP, 'Ssid', dbus_interface=DBUS_PROPS, byte_arrays=True)

    print(ssid)

if __name__ == '__main__':
    main()
