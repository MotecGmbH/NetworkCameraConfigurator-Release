local d = require 'debug'		-- activate debug library (not sure if i need this)


-- Add entries in this table to add them to the dissector
--            	  	  CatCo    		Description  									Type
Properties = {  
	-- Network	
-- ======================
-- Network (0x00xx)
-- ======================
DevIP            = { 0x0000, "Device IP",                         "ipv4"  },
DestIP           = { 0x0001, "Stream Destination IP",             "ipv4"  },
DestPort         = { 0x0002, "Stream Destination Port",           "uint16"},
Codec             = { 0x0003, "Video Codec",                      "uint16"},
H264Compr         = { 0x0004, "H.264 Compression (deprecated)",   "hex"   },
MjpegCompr        = { 0x0005, "MJPEG Compression (deprecated)",   "hex"   },
Resolution        = { 0x0006, "Resolution",                       "uint16"},
Framerate         = { 0x0007, "Framerate",                        "uint16"},
Cropping          = { 0x0008, "Cropping",                         "uint16"},
StreamEnable0     = { 0x0009, "Stream On/Off",                    "bool"  },
MAC               = { 0x000B, "MAC Address",                      "MAC"   },
DHCP              = { 0x000C, "DHCP",                             "bool"  },
Subnetmask        = { 0x000D, "Subnet Mask",                      "ipv4"  },
StreamingMac      = { 0x000E, "Streaming Destination MAC",        "MAC"   },
StreamProtocol0   = { 0x0010, "Stream Protocol",                  "uint16"},
TimeSync          = { 0x0014, "Time Synchronisation",             "uint16"},
IpViaMac          = { 0x0015, "IP via MAC",                       "ipvmac"},

-- ======================
-- System (0x01xx)
-- ======================
Reboot            = { 0x0100, "Reboot",                           "null"  },
FactoryDefault    = { 0x0101, "Factory Default",                  "null"  },
Bootloader        = { 0x0102, "Switch to Bootloader",             "null"  },
DeviceName        = { 0x0103, "Device Name",                      "string"},
DeviceSerial      = { 0x0104, "Device Serial Number",             "string"},
DeviceArticle     = { 0x0105, "Device Article Number",            "string"},
SoftwareVersion   = { 0x0106, "Software Version",                 "string"},
BootloaderVersion = { 0x0107, "Bootloader Version",               "string"},
Status            = { 0x0108, "Status",                           "hex"   },
IspHash           = { 0x010A, "ISP Hash",                         "hex"   },
PhyDiagnostic     = { 0x010B, "PHY Diagnostic",                   "hex"   },
FieldOfView       = { 0x010C, "Field Of View",                    "uint16"},
LoadCmdSequence   = { 0x010F, "Load Command Sequence",            "uint16"},
SomeIPSDPort      = { 0x0116, "SomeIP SD Port",                   "uint16"},
SomeIPPort        = { 0x0117, "SomeIP Port",                      "uint16"},
SemanticVersion   = { 0x0119, "Semantic Software Version",        "string"},
RTSPControl       = { 0x011A, "RTSP Control",                     "string"},

-- ======================
-- Image / ISP Functions (0x02xx)
-- ======================
Mirror             = { 0x0200, "Mirroring",                       "bool"  },
Monochrome         = { 0x0201, "Monochrome",                      "bool"  },
Gamma              = { 0x0202, "Gamma",                           "uint16"},
Brightness         = { 0x0203, "Brightness",                      "uint16"},
Sharpness          = { 0x0204, "Sharpness",                       "uint16"},
AeZoneWeights      = { 0x0205, "Auto Exposure Zone Weights",      "hex"   },
ManualGamma        = { 0x0206, "Manual Gamma",                    "bool"  },
ManualBrightness   = { 0x0207, "Manual Brightness",               "bool"  },
ManualSharpness    = { 0x0208, "Manual Sharpness",                "bool"  },
AeExclusionWindow  = { 0x0209, "AE Exclusion Window",             "uint16"},
TransparentISPAcc  = { 0x020A, "Transparent ISP Register Access", "hex"   },
SetLiveIndicator   = { 0x020C, "Set Live Indicator",              "uint16"},
ManualExposure     = { 0x020D, "Manual Exposure",                 "uint16"},
Gain               = { 0x020E, "Gain",                            "uint16"},
ExposureTime       = { 0x020F, "Exposure Time",                   "uint16"},

-- ======================
-- Stream per Index (0x03xx)
-- ======================
StreamDestIP       = { 0x0300, "Stream Destination IP",           "ipv4"	},
StreamDestPort     = { 0x0301, "Stream Destination Port",         "uint16"  },
StreamCodec        = { 0x0302, "Stream Codec",                    "uint16"  },
StreamFramerate    = { 0x0303, "Stream Framerate",                "uint16"  },
StreamCropping     = { 0x0304, "Stream Cropping",                 "uint16"  },
StreamMaxBitrate   = { 0x0305, "Stream Max Bitrate",              "uint16"  },
StreamMaxQuality   = { 0x0306, "Stream Max Quality",              "uint8"   },
StreamMirroring    = { 0x0308, "Stream Mirroring",                "uint8"   },
NumStreams         = { 0x0309, "Number of Available Streams",     "uint8" 	},
VlanId             = { 0x030A, "VLAN ID",                         "uint8"   },
StreamResolution   = { 0x030B, "Stream Resolution",               "uint16"  },
StreamProtocol     = { 0x030C, "Stream Protocol",                 "uint8"  },
StreamEnable       = { 0x030D, "Enable Stream",                   "bool"   	},

-- ======================
-- Display (0x20xx)
-- ======================
BacklightMode      = { 0x2000, "Screen Backlight Mode",           "hex"   },
ScreenEnable       = { 0x2001, "Screen ON/OFF",                   "bool"  },
ViewModeList       = { 0x2002, "View Mode List",                  "VM"    },
CurrentVMName      = { 0x2003, "Current View Mode (Name)",        "string"},
CurrentVM          = { 0x2004, "Current View Mode (Mode)",        "VM"    },
AddViewMode        = { 0x2005, "Add View Mode",                   "VM"    },
DeleteViewMode     = { 0x2006, "Delete View Mode",                "VM"    },
ShortcutList       = { 0x2007, "Shortcut List",                   "string"},
ScreenBrightness   = { 0x2008, "Screen Brightness",               "uint8" },
Buzzer             = { 0x2009, "Buzzer",                          "hex"   },
MenuPin            = { 0x200A, "Menu Pin",                        "hex"   },

-- ======================
-- CWS / Detection (0x50xx)
-- ======================
EnablePersonDetection   = { 0x5000, "Enable Person Detection",     "bool" },
DetectedObjectMetaData  = { 0x5001, "Detected Object Meta Data",   "hex"  },
MetaDataEndpoint        = { 0x5002, "Meta Data Endpoint",          "hex"  },
EnableDetectionOverlay  = { 0x5003, "Enable Detection Overlays",   "bool" },
EnableStreamBuzzer      = { 0x5004, "Enable Buzzer",               "bool" },

-- ======================
-- EMS / Manufacturing (0xF0xx)
-- ======================
ConnectorSerial   = { 0xF000, "Connector Serial",                 "string"},
MainboardSerial   = { 0xF001, "Mainboard Serial",                 "string"},
SensorSerial      = { 0xF002, "Sensor Serial",                    "string"},

-- ======================
-- MVCD / External
-- ======================
ExternalAlarm     = { 0x3000, "External Alarm",                   "hex"   },


}

TYPES =
	{
		READ 		= 1,
		WRITE 		= 2, 
		DATA 		= 3, 
		ACK 		= 4, 
		ERROR 		= 5,
		HEARTBEAT 	= 6
	} 
-- This is the protocol you use to filter
Motec_protocol = Proto("Motec", "Motec Protocol")

-- These are the attributes you can filter for in wireshark
message_version = ProtoField.uint8("Motec.Version", "Version	", base.HEX)
message_type = ProtoField.uint8("Motec.Type", "Type	", base.HEX)
message_segment = ProtoField.uint16("Motec.Segment", "SegmentNo	", base.HEX)
message_lenght = ProtoField.uint16("Motec.Length", "Lenght	", base.HEX)
message_category = ProtoField.uint8("Motec.Category", "Category	", base.HEX)
message_command = ProtoField.uint8("Motec.Command", "Command	", base.HEX)
message_config = ProtoField.uint8("Motec.Config", "Configuration", base.HEX)
message_error = ProtoField.uint16("Motec.Error", "Error	", base.HEX)
message_payload = ProtoField.uint16("Motec.Payload_Hex", "Payload	", base.HEX)


--
Motec_protocol.fields = {
    message_version,
    message_type,
    message_segment,
    message_lenght,
    message_category,
    message_command,
    message_config,
    message_error,
    message_payload,

}

function Motec_protocol.dissector(buffer, pinfo, tree)
    --dont do anything if there is no data
    length = buffer:len()
    if length == 0 then
        return
    end
    --needed?
    pinfo.cols.protocol = "Motec"

    --create subtree
    local subtree = tree:add(Motec_protocol, buffer(), "Motec Protocol Data")

    --extract attributes from buffer
    local version = buffer(0, 1)
    local type = buffer(1, 1)
    local segementNo = buffer(2, 2)
	if type:uint() == 0x04 then
		local ackText = "Acknowledge"           -- string to append to info_text
		pinfo.cols.info:set(ackText)
	end

    


    --Add protocol attributes to tree
	local type_name = get_type_name(buffer(1, 1):uint())
    subtree:add(message_version, version):append_text("	(" .. version:uint() .. ")")  --Add Version
    subtree:add(message_type, type):append_text("	(" .. type_name .. ")") --Add Type
    subtree:add(message_segment, segementNo):append_text("	(" .. segementNo:uint() .. ")") --Segment
	
    --if (type:uint() == TYPES.ERROR) then
    --    subtree:add(message_lenght, length):append_text("	(" .. length:uint() .. ")")
	
    if (type:uint() == TYPES.READ or type:uint() == TYPES.WRITE or type:uint() == TYPES.DATA) then
        
		local length = buffer(4, 2)
		local category = buffer(6, 1)
		local command = buffer(7, 1)
		local catco = buffer(6, 2)
		local payload = buffer(8)
		if category:uint() == 0x03 then
			payload = buffer(9)
		end
		local unknownCommand = true
		local cmd_name = "Unknown"
		for k, v in pairs(Properties) do
			if v[1] == catco:uint() or v[1] == (catco:uint() - 0x80) then
				cmd_name = v[2]
				subtree:add(message_command, command):append_text(" (" .. v[2] .. ")")
				unknownCommand = false
				break
			end
		end
		
		-- cache type and category values
local type_val = type:uint()
local category_val = category:uint()

-- initial info text
local info_text = string.format(
    "%s %s",
    get_type_name(type_val),
    --get_category_name(category_val),
    cmd_name
)

local category_name = get_category_name(category_val)

-- add basic fields to tree
subtree:add(message_lenght, length):append_text(" (" .. length:uint() .. ")")
subtree:add(message_category, category):append_text(" (" .. category_name .. ")")

-- iterate over properties
for k, v in pairs(Properties) do
    local catco_val = catco:uint()
    if v[1] == catco_val or v[1] == catco_val - 0x80 then
        subtree:add(message_command, command):append_text(" (" .. v[2] .. ")")
        unknownCommand = false

        if payload:len() > 0 then
            local payloadtype = v[3]
            local display_text = ""          -- string to append to subtree
            local info_append = ""           -- string to append to info_text
            local hexval = payload:bytes():tohex()

            -- determine display string based on type
            if payloadtype == "ipv4" then
                display_text = " (" .. userDataToIp(payload) .. ")"
                info_append = display_text
            elseif payloadtype == "ipvmac" then
                display_text = " (" .. userDataToIpViaMac(payload) .. ")"
                info_append = display_text
            elseif payloadtype == "bool" then
                display_text = " (" .. tostring(userDataToBool(payload)) .. ")"
                info_append = display_text
            elseif payloadtype == "uint16" then
                display_text = " (" .. userDataToUint16Array(payload) .. ")"
                info_append = display_text
            elseif payloadtype == "MAC" then
                display_text = " (" .. userDataToMac(payload) .. ")"
                info_append = display_text
            elseif payloadtype == "string" then
                display_text = " (" .. payload:string() .. ")"
                info_append = display_text
            elseif payloadtype == "hex" then
                display_text = " (" .. userDataToArray(payload) .. ")"
                info_append = display_text
            else
                -- fallback
                display_text = " 0x" .. hexval
                info_append = display_text
            end

            -- now append once to subtree and info_text
            subtree:add("Payload :"):append_text(display_text)
            info_text = info_text .. info_append
        end
    end
end

-- finally, set the info column
pinfo.cols.info:set(info_text)

        if unknownCommand then
            subtree:add(message_command, command):append_text(" 	(Unknown)" .. command:uint() .. "")
        end

        
    end
    if (type_name == "ERROR") then
		local length = buffer(4, 2)
		subtree:add(message_lenght, length):append_text("	(" .. length:uint() .. ")")
        local error_no = buffer(6, 2):uint()
        local error_name = get_error_name(error_no)
        subtree:add(message_error, buffer(6, 2)):append_text(" 	(" .. error_name .. ")")
		pinfo.cols.info:set("ERROR (" .. error_name .. ")")

    end
end

local udp_port = DissectorTable.get("udp.port")
udp_port:add(8885, Motec_protocol)

function userDataToIp(buf)
	local str = ""
	for i = 0,buf:len()-1,1 do 
		if(i > 0) then
			str = str .."."
		end
		str = str .. buf(i,1):uint()
	end
	return str
end

function userDataToIpViaMac(buf)
    local mac = ""
    local ip = ""

    -- MAC-Adresse (6 Bytes)
    for i = 0, 5 do
        if i > 0 then mac = mac .. ":" end
        mac = mac .. string.format("%02X", buf(i,1):uint())
    end

    -- IP-Adresse (4 Bytes)
    for i = 6, 9 do
        if i > 6 then ip = ip .. "." end
        ip = ip .. tostring(buf(i,1):uint())
    end

    return "MAC: " .. mac .. " | IP: " .. ip
end

function userDataToMac(buf)
	local str = ""
	for i = 0,buf:len()-1,1 do 
		if(i > 0) then
			str = str ..":"
		end
		str = str .. buf(i,1)
	end
	return str
end

function userDataToArray(buf)
	local str = ""
	for i = 0,buf:len()-1,1 do 
		if(i > 0) then
			str = str .." "
		end
		str = str .. buf(i,1)
	end
	return str
end



function userDataToUint16Array(userdata)	
	local str = ""
						
	for i = 0,userdata:len()-1,2 do 
		if(i > 0) then
			str = str ..","
		end
		str = str .. userdata(i,2):uint()
	end
	return str
end


function userDataToBool(userdata)	
	local val = userdata:uint()						
	if(val == 0) then
		return "Off"
	end
	return "On"
end

function get_type_name(type)
    local type_name = "Unknown"

    if type == 1 then
        type_name = "READ"
    elseif type == 2 then
        type_name = "WRITE"
    elseif type == 3 then
        type_name = "DATA"
    elseif type == 4 then
        type_name = "ACK"
    elseif type == 5 then
        type_name = "ERROR"
    elseif type == 6 then
        type_name = "HEARTBEAT"
    end

    return type_name
end

function get_error_name(error_no)
    local error_name = "Unknown"

    if error_no == 0 then
        error_name = "No Error"
    elseif error_no == 1 then
        error_name = "Type Unknown"
    elseif error_no == 2 then
        error_name = "CMD/CFG Unknown"
    elseif error_no == 3 then
        error_name = "Category Unknown"
    elseif error_no == 4 then
        error_name = "DATA Unknown"
    elseif error_no == 5 then
        error_name = "Wrong protocol version"
    elseif error_no == 6 then
        error_name = "Parameter error"
    elseif error_no == 7 then
        error_name = "Access error"
    elseif error_no == 8 then
        error_name = "Sequence error"
    elseif error_no == 9 then
        error_name = "Lenght error"
    elseif error_no == 10 then
        error_name = "ISP error"    
	elseif error_no == 11 then
        error_name = "Internal error"    
	elseif error_no == 12 then
        error_name = "External error"    
	elseif error_no == 13 then
        error_name = "Invalid Stream Index"
    end

    return error_name
end

function get_category_name(category)
    local category_name = "Unknown"

    if category == 0 then
        category_name = "NETWORK"
    elseif category == 1 then
        category_name = "SYSTEM"
    elseif category == 2 then
        category_name = "FUNCTION"    
		elseif category == 3 then
        category_name = "Stream specific"
    elseif category == 0x10 then
        category_name = "APPLICATION (Krone LRE)"    
	elseif category == 0x20 then
		category_name = "Display"	
	elseif category == 0x30 then
		category_name = "MVCD"		
	elseif category == 0x30 then
		category_name = "BMS"			
	elseif category == 0x50 then
		category_name = "CWS"	
	elseif category == 0xF0 then
		category_name = "EMS"
    end

    return category_name
end


