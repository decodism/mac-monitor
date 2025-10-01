//
//  UIPCConnectEvent.swift
//  ProjectSutro
//
//  Created by Brandon Dalton on 10/1/25.
//

// https://developer.apple.com/documentation/endpointsecurity/es_event_uipc_connect_t
public struct UIPCConnectEvent: Identifiable, Codable, Hashable {
    public var id: UUID = UUID()
    
    public var file: File
    public var domain, type, `protocol`: Int32
    
    public var type_string, domain_string, protocol_string: String
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public static func == (lhs: UIPCConnectEvent, rhs: UIPCConnectEvent) -> Bool {
        return lhs.id == rhs.id
    }
    
    init(from rawMessage: UnsafePointer<es_message_t>) {
        let event: es_event_uipc_connect_t = rawMessage.pointee.event.uipc_connect
        
        file = File(from: event.file.pointee)
        domain = event.domain
        `protocol` = event.protocol
        type = event.type
        
        switch event.type {
        case SOCK_STREAM:
            type_string = "SOCK_STREAM"
        case SOCK_DGRAM:
            type_string = "SOCK_DGRAM"
        case SOCK_SEQPACKET:
            type_string = "SOCK_SEQPACKET"
        case SOCK_RAW:
            type_string = "SOCK_RAW"
        case SOCK_RDM:
            type_string = "SOCK_RDM"
        default:
            type_string = "UNKNOWN"
        }
        
        switch event.domain {
        case AF_UNSPEC:
            domain_string = "AF_UNSPEC"
        case AF_UNIX:
            domain_string = "AF_UNIX"
        case AF_LOCAL:
            domain_string = "AF_LOCAL"
        case AF_INET:
            domain_string = "AF_INET"
        case AF_IMPLINK:
            domain_string = "AF_IMPLINK"
        case AF_PUP:
            domain_string = "AF_PUP"
        case AF_CHAOS:
            domain_string = "AF_CHAOS"
        case AF_NS:
            domain_string = "AF_NS"
        case AF_ISO:
            domain_string = "AF_ISO"
        case AF_OSI:
            domain_string = "AF_OSI"
        case AF_ECMA:
            domain_string = "AF_ECMA"
        case AF_DATAKIT:
            domain_string = "AF_DATAKIT"
        case AF_CCITT:
            domain_string = "AF_CCITT"
        case AF_SNA:
            domain_string = "AF_SNA"
        case AF_DECnet:
            domain_string = "AF_DECnet"
        case AF_DLI:
            domain_string = "AF_DLI"
        case AF_LAT:
            domain_string = "AF_LAT"
        case AF_HYLINK:
            domain_string = "AF_HYLINK"
        case AF_APPLETALK:
            domain_string = "AF_APPLETALK"
        case AF_ROUTE:
            domain_string = "AF_ROUTE"
        case AF_LINK:
            domain_string = "AF_LINK"
        case pseudo_AF_XTP:
            domain_string = "pseudo_AF_XTP"
        case AF_COIP:
            domain_string = "AF_COIP"
        case AF_CNT:
            domain_string = "AF_CNT"
        case pseudo_AF_RTIP:
            domain_string = "pseudo_AF_RTIP"
        case AF_IPX:
            domain_string = "AF_IPX"
        case AF_SIP:
            domain_string = "AF_SIP"
        case pseudo_AF_PIP:
            domain_string = "pseudo_AF_PIP"
        case AF_NDRV:
            domain_string = "AF_NDRV"
        case AF_ISDN:
            domain_string = "AF_ISDN"
        case AF_E164:
            domain_string = "AF_E164"
        case pseudo_AF_KEY:
            domain_string = "pseudo_AF_KEY"
        case AF_INET6:
            domain_string = "AF_INET6"
        case AF_NATM:
            domain_string = "AF_NATM"
        case AF_SYSTEM:
            domain_string = "AF_SYSTEM"
        case AF_NETBIOS:
            domain_string = "AF_NETBIOS"
        case AF_PPP:
            domain_string = "AF_PPP"
        case pseudo_AF_HDRCMPLT:
            domain_string = "pseudo_AF_HDRCMPLT"
        case AF_RESERVED_36:
            domain_string = "AF_RESERVED_36"
        case AF_IEEE80211:
            domain_string = "AF_IEEE80211"
        case AF_UTUN:
            domain_string = "AF_UTUN"
        case AF_VSOCK:
            domain_string = "AF_VSOCK"
        default:
            domain_string = "UNKNOWN(\(event.domain))"
        }
        
        switch event.protocol {
        case 0:
            protocol_string = "DEFAULT"
        case IPPROTO_IP:
            protocol_string = "IPPROTO_IP"
        case IPPROTO_HOPOPTS:
            protocol_string = "IPPROTO_HOPOPTS"
        case IPPROTO_ICMP:
            protocol_string = "IPPROTO_ICMP"
        case IPPROTO_IGMP:
            protocol_string = "IPPROTO_IGMP"
        case IPPROTO_GGP:
            protocol_string = "IPPROTO_GGP"
        case IPPROTO_IPV4:
            protocol_string = "IPPROTO_IPV4"
        case IPPROTO_IPIP:
            protocol_string = "IPPROTO_IPIP"
        case IPPROTO_TCP:
            protocol_string = "IPPROTO_TCP"
        case IPPROTO_ST:
            protocol_string = "IPPROTO_ST"
        case IPPROTO_EGP:
            protocol_string = "IPPROTO_EGP"
        case IPPROTO_PIGP:
            protocol_string = "IPPROTO_PIGP"
        case IPPROTO_RCCMON:
            protocol_string = "IPPROTO_RCCMON"
        case IPPROTO_NVPII:
            protocol_string = "IPPROTO_NVPII"
        case IPPROTO_PUP:
            protocol_string = "IPPROTO_PUP"
        case IPPROTO_ARGUS:
            protocol_string = "IPPROTO_ARGUS"
        case IPPROTO_EMCON:
            protocol_string = "IPPROTO_EMCON"
        case IPPROTO_XNET:
            protocol_string = "IPPROTO_XNET"
        case IPPROTO_CHAOS:
            protocol_string = "IPPROTO_CHAOS"
        case IPPROTO_UDP:
            protocol_string = "IPPROTO_UDP"
        case IPPROTO_MUX:
            protocol_string = "IPPROTO_MUX"
        case IPPROTO_MEAS:
            protocol_string = "IPPROTO_MEAS"
        case IPPROTO_HMP:
            protocol_string = "IPPROTO_HMP"
        case IPPROTO_PRM:
            protocol_string = "IPPROTO_PRM"
        case IPPROTO_IDP:
            protocol_string = "IPPROTO_IDP"
        case IPPROTO_TRUNK1:
            protocol_string = "IPPROTO_TRUNK1"
        case IPPROTO_TRUNK2:
            protocol_string = "IPPROTO_TRUNK2"
        case IPPROTO_LEAF1:
            protocol_string = "IPPROTO_LEAF1"
        case IPPROTO_LEAF2:
            protocol_string = "IPPROTO_LEAF2"
        case IPPROTO_RDP:
            protocol_string = "IPPROTO_RDP"
        case IPPROTO_IRTP:
            protocol_string = "IPPROTO_IRTP"
        case IPPROTO_TP:
            protocol_string = "IPPROTO_TP"
        case IPPROTO_BLT:
            protocol_string = "IPPROTO_BLT"
        case IPPROTO_NSP:
            protocol_string = "IPPROTO_NSP"
        case IPPROTO_INP:
            protocol_string = "IPPROTO_INP"
        case IPPROTO_SEP:
            protocol_string = "IPPROTO_SEP"
        case IPPROTO_3PC:
            protocol_string = "IPPROTO_3PC"
        case IPPROTO_IDPR:
            protocol_string = "IPPROTO_IDPR"
        case IPPROTO_XTP:
            protocol_string = "IPPROTO_XTP"
        case IPPROTO_DDP:
            protocol_string = "IPPROTO_DDP"
        case IPPROTO_CMTP:
            protocol_string = "IPPROTO_CMTP"
        case IPPROTO_TPXX:
            protocol_string = "IPPROTO_TPXX"
        case IPPROTO_IL:
            protocol_string = "IPPROTO_IL"
        case IPPROTO_IPV6:
            protocol_string = "IPPROTO_IPV6"
        case IPPROTO_SDRP:
            protocol_string = "IPPROTO_SDRP"
        case IPPROTO_ROUTING:
            protocol_string = "IPPROTO_ROUTING"
        case IPPROTO_FRAGMENT:
            protocol_string = "IPPROTO_FRAGMENT"
        case IPPROTO_IDRP:
            protocol_string = "IPPROTO_IDRP"
        case IPPROTO_RSVP:
            protocol_string = "IPPROTO_RSVP"
        case IPPROTO_GRE:
            protocol_string = "IPPROTO_GRE"
        case IPPROTO_MHRP:
            protocol_string = "IPPROTO_MHRP"
        case IPPROTO_BHA:
            protocol_string = "IPPROTO_BHA"
        case IPPROTO_ESP:
            protocol_string = "IPPROTO_ESP"
        case IPPROTO_AH:
            protocol_string = "IPPROTO_AH"
        case IPPROTO_INLSP:
            protocol_string = "IPPROTO_INLSP"
        case IPPROTO_SWIPE:
            protocol_string = "IPPROTO_SWIPE"
        case IPPROTO_NHRP:
            protocol_string = "IPPROTO_NHRP"
        case IPPROTO_ICMPV6:
            protocol_string = "IPPROTO_ICMPV6"
        case IPPROTO_NONE:
            protocol_string = "IPPROTO_NONE"
        case IPPROTO_DSTOPTS:
            protocol_string = "IPPROTO_DSTOPTS"
        case IPPROTO_AHIP:
            protocol_string = "IPPROTO_AHIP"
        case IPPROTO_CFTP:
            protocol_string = "IPPROTO_CFTP"
        case IPPROTO_HELLO:
            protocol_string = "IPPROTO_HELLO"
        case IPPROTO_SATEXPAK:
            protocol_string = "IPPROTO_SATEXPAK"
        case IPPROTO_KRYPTOLAN:
            protocol_string = "IPPROTO_KRYPTOLAN"
        case IPPROTO_RVD:
            protocol_string = "IPPROTO_RVD"
        case IPPROTO_IPPC:
            protocol_string = "IPPROTO_IPPC"
        case IPPROTO_ADFS:
            protocol_string = "IPPROTO_ADFS"
        case IPPROTO_SATMON:
            protocol_string = "IPPROTO_SATMON"
        case IPPROTO_VISA:
            protocol_string = "IPPROTO_VISA"
        case IPPROTO_IPCV:
            protocol_string = "IPPROTO_IPCV"
        case IPPROTO_CPNX:
            protocol_string = "IPPROTO_CPNX"
        case IPPROTO_CPHB:
            protocol_string = "IPPROTO_CPHB"
        case IPPROTO_WSN:
            protocol_string = "IPPROTO_WSN"
        case IPPROTO_PVP:
            protocol_string = "IPPROTO_PVP"
        case IPPROTO_BRSATMON:
            protocol_string = "IPPROTO_BRSATMON"
        case IPPROTO_ND:
            protocol_string = "IPPROTO_ND"
        case IPPROTO_WBMON:
            protocol_string = "IPPROTO_WBMON"
        case IPPROTO_WBEXPAK:
            protocol_string = "IPPROTO_WBEXPAK"
        case IPPROTO_EON:
            protocol_string = "IPPROTO_EON"
        case IPPROTO_VMTP:
            protocol_string = "IPPROTO_VMTP"
        case IPPROTO_SVMTP:
            protocol_string = "IPPROTO_SVMTP"
        case IPPROTO_VINES:
            protocol_string = "IPPROTO_VINES"
        case IPPROTO_TTP:
            protocol_string = "IPPROTO_TTP"
        case IPPROTO_IGP:
            protocol_string = "IPPROTO_IGP"
        case IPPROTO_DGP:
            protocol_string = "IPPROTO_DGP"
        case IPPROTO_TCF:
            protocol_string = "IPPROTO_TCF"
        case IPPROTO_IGRP:
            protocol_string = "IPPROTO_IGRP"
        case IPPROTO_OSPFIGP:
            protocol_string = "IPPROTO_OSPFIGP"
        case IPPROTO_SRPC:
            protocol_string = "IPPROTO_SRPC"
        case IPPROTO_LARP:
            protocol_string = "IPPROTO_LARP"
        case IPPROTO_MTP:
            protocol_string = "IPPROTO_MTP"
        case IPPROTO_AX25:
            protocol_string = "IPPROTO_AX25"
        case IPPROTO_IPEIP:
            protocol_string = "IPPROTO_IPEIP"
        case IPPROTO_MICP:
            protocol_string = "IPPROTO_MICP"
        case IPPROTO_SCCSP:
            protocol_string = "IPPROTO_SCCSP"
        case IPPROTO_ETHERIP:
            protocol_string = "IPPROTO_ETHERIP"
        case IPPROTO_ENCAP:
            protocol_string = "IPPROTO_ENCAP"
        case IPPROTO_APES:
            protocol_string = "IPPROTO_APES"
        case IPPROTO_GMTP:
            protocol_string = "IPPROTO_GMTP"
        case IPPROTO_PIM:
            protocol_string = "IPPROTO_PIM"
        case IPPROTO_IPCOMP:
            protocol_string = "IPPROTO_IPCOMP"
        case IPPROTO_PGM:
            protocol_string = "IPPROTO_PGM"
        case IPPROTO_SCTP:
            protocol_string = "IPPROTO_SCTP"
        case IPPROTO_DIVERT:
            protocol_string = "IPPROTO_DIVERT"
        case IPPROTO_RAW:
            protocol_string = "IPPROTO_RAW"
        case IPPROTO_DONE:
            protocol_string = "IPPROTO_DONE"
        default:
            protocol_string = "UNKNOWN(\(event.protocol))"
        }
    }
}
