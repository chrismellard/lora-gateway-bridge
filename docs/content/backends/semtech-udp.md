---
title: Semtech UDP
description: Semtech UDP packet-forwarder backend.
menu:
  main:
    parent: backends
---

# Semtech UDP packet-forwarder backend

The [Semtech UDP packet-forwarder](https://github.com/lora-net/packet_forwarder)
backend abstracts the [UDP protocol](https://github.com/Lora-net/packet_forwarder/blob/master/PROTOCOL.TXT).

It is compatible with:

* v1 of the protocol
* v2 of the protocol
* Modified format used by the [Kerlink iBTS](https://www.kerlink.com/product/wirnet-ibts/)
  containing the (encrypted) fine-timestamp

## Configuration

When the `semtech_udp` backend has been enabled, make sure your packet-forwarder
`global_conf.json` or `local_conf.json` is configured correctly, under `gateway_conf`,
the `server_address`, `serv_port_up` and `serv_port_down` must be configured so
that data is forwarded to the LoRa Gateway Bridge instance.

{{<highlight text>}}
"gateway_conf": {
	"gateway_ID": "AA555A0000000000",
	"server_address": "localhost",
	"serv_port_up": 1700,
	"serv_port_down": 1700,
	...
}
{{</highlight>}}

## Deployment

The LoRa Gateway Bridge can be deployed either on the gateway (recommended)
and "in the cloud". In the latter case, multiple gateways can connect to the
same LoRa Gateway Bridge instance.

When the LoRa Gateway Bridge is deployed on the gateway, you will benefit from
the MQTT authentication / authorization layer and optional TLS.

## Packet-forwarder re-configuration over MQTT

The Semtech UDP backend supports the re-configuration of the packet-forwarder
over MQTT using the `config` [Commands]({{<ref "payloads/commands.md">}}).

This works as follow:

* The LoRa Gateway Bridge will periodically send `stats` [Events]({{<relref "payloads/events.md">}})
  containing the current configuration version.
* [LoRa Server](/loraserver/) processes these stats events and when a _Gateway Profile_
  is associated with the gateway, it will compare the configuration version.
* In case the _Gateway Profile_ version is newer, it will send a `config`
  command to the LoRa Gateway Bridge.
* LoRa Gateway Bridge will then read the `base_file`, update it and writes it
  to the `output_file`.
* It then restarts the packet-forwarder using the `restart_command` causing the
  packet-forwarder to reload its configuration.

For the above to work, you must configure the _Mandaged packet-forwarder configuration_
section in the `lora-gateway-bridge.toml`.

