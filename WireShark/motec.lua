-- https://mika-s.github.io/wireshark/lua/dissector/2017/11/08/creating-a-wireshark-dissector-in-lua-3.html

local d = require 'debug'		-- activate debug library

debug_motec_protocol = true   

motec_protocol = Proto("Motec",  "Motec Protocol")

-- HEADER
message_proto_version =  ProtoField.uint8("motec.message_protp_version", "Version", base.DEC)
message_type = ProtoField.uint8("motec.message_type", "Type", base.DEC)
message_segment = ProtoField.uint16("motec.message_segment", "SegmentNo", base.HEX)
message_lenght =  ProtoField.uint16("motec.message_length", "Lenght", base.DEC)
message_category = ProtoField.uint8("motec.message_category", "Category", base.DEC)
message_command = ProtoField.uint8("motec.message_command", "Command", base.HEX)
message_config = ProtoField.uint8("motec.message_config", "Configuration", base.HEX)
message_error = ProtoField.uint16("motec.message_error", "Error", base.HEX)

-- NETWORK DATA
message_ip_addr = ProtoField.ipv4("motec.message_ip_addr", "IPAddr")
message_stream_port = ProtoField.uint16("motec.message_stream_port", "Streaming port")
message_stream_type = ProtoField.uint16("motec.message_stream_type", "Codec")
message_h264_compression_cqp = ProtoField.uint16("motec.message_h264_compression_cqp", "Compression (CQP)")
message_h264_compression_vbr = ProtoField.uint16("motec.message_h264_compression_vbr", "Compression (VBR)")
message_mjpg_compression_q = ProtoField.uint16("motec.message_mjpg_compression", "Compression (Q)")
message_mjpg_compression_cbr = ProtoField.uint16("motec.message_mjpg_compression", "Compression (CBR)")
message_resolution_x = ProtoField.uint16("motec.message_resolution_x", "X")
message_resolution_y = ProtoField.uint16("motec.message_resolution_y", "Y")
message_fps = ProtoField.uint16("motec.message_fps", "FPS")
message_resolution_width = ProtoField.uint16("motec.message_resolution_width", "Width")
message_resolution_height = ProtoField.uint16("motec.message_resolution_height", "Height")
message_stream_on_off = ProtoField.uint16("motec.message_stream_on_off", "Stream ON/OFF")
message_mac_addr = ProtoField.ether("motec.message_mac_addr", "MACAddr")
message_dhcp = ProtoField.uint16("motec.message_dhcp", "DHCP")
message_subnet_mask = ProtoField.ipv4("motec.message_subnet_mask", "Subnetmask")

-- SYSTEM DATA
message_cam_name = ProtoField.string("motec.message_cam_name", "Name")
message_cam_serial = ProtoField.string("motec.message_cam_serial", "Serial")
message_cam_article = ProtoField.string("motec.message_cam_article", "Article")
message_cam_sw_version = ProtoField.string("motec.message_cam_sw_version", "SW version")
message_cam_bootloader_version = ProtoField.string("motec.message_cam_bootloader_version", "Bootloader version")
message_cam_protocol_version = ProtoField.uint8("motec.message_cam_protocol_version", "Protocol version")
message_cam_heartbeat_settings = ProtoField.uint8("motec.message_cam_heartbeat_settings", "Heartbeat Settings")
message_cam_isp_register_address = ProtoField.uint16("motec.message_cam_isp_register_address", "ISP Register", base.HEX)
message_cam_isp_register_type = ProtoField.uint8("motec.message_cam_isp_register_type", "ISP Register Type")
message_cam_isp_register_value = ProtoField.uint32("motec.message_cam_isp_register_value", "ISP Register Value", base.HEX)
message_cam_heartbeat_interval = ProtoField.uint16("motec.message_cam_heartbeat_interval", "Interval", base.DEC)
message_cam_heartbeat_destination_IP = ProtoField.ipv4("motec.message_cam_heartbeat_destination_IP", "Destination IP", base.HEX)
message_cam_heartbeat_destination_Port = ProtoField.uint16("motec.message_cam_heartbeat_destination_Port", "Destination Port", base.DEC)


-- FUNCTION DATA
message_mirror_h = ProtoField.uint8("motec.message_mirror_h", "Mirror H")
message_mirror_v = ProtoField.uint8("motec.message_mirror_v", "Mirror V")
message_monocrome = ProtoField.uint16("motec.message_monocrome", "Monocrome")
message_contrast = ProtoField.uint16("motec.message_contrast", "Contrast")
message_brightness = ProtoField.uint16("motec.message_brightness", "Brightness")
message_sharpness = ProtoField.uint16("motec.message_sharpness", "Sharpness")

-- Heartbeat DATA
message_status = ProtoField.uint16("motec.message_status", "Status")
-- APPLICATION Krone LRE
--message_start_calc = ProtoField.uint8("motec.message_mirror_h", "Mirror H")

motec_protocol.fields = {
  message_proto_version,message_type,message_segment,message_lenght,message_category,message_command,message_config,message_error,    					--HEADER
  message_ip_addr,message_stream_port,message_stream_type,message_h264_compression_cqp,message_h264_compression_vbr,message_mjpg_compression_q,			--NETWORK DATA
  message_resolution_x,message_resolution_y,message_fps,message_resolution_width,message_resolution_height,message_subnet_mask,message_stream_on_off,
  message_mac_addr,message_dhcp,message_mjpg_compression_cbr,message_cam_heartbeat_settings,
  message_cam_name,message_cam_serial,message_cam_article,message_cam_sw_version,message_cam_bootloader_version,message_cam_protocol_version,			--SYSTEM DATA
  message_cam_isp_register_address, message_cam_isp_register_type,message_cam_isp_register_value, message_sharpness,message_brightness,message_contrast,
  message_mirror_h,message_mirror_v,message_monocrome,	message_cam_heartbeat_interval,message_cam_heartbeat_destination_IP,message_cam_heartbeat_destination_Port,																								--FUNCTION DATA
  message_status																																	    --STATUS DATA
}

function motec_protocol.dissector(buffer, pinfo, tree)
  local command_name
  length = buffer:len()
  if length == 0 then return end

  pinfo.cols.protocol = motec_protocol.name

  local subtree = tree:add(motec_protocol, buffer(), "Motec Protocol Data")
  
 -- if debug_motec_protocol then debug("decoding motec protocol " .. buffer:len()) end
  --info(d.traceback()) end
-- add_le => little endian
  if (length == 47) then
	subtree:add(message_proto_version, buffer(0,1))
	local datatree = subtree:add(motec_protocol, buffer(), "Heartbeat")
	datatree:add(message_ip_addr, buffer(1,4))
	datatree:add(message_cam_name, buffer(5,32))
	datatree:add(message_stream_port, buffer(37,2))
	datatree:add(message_mac_addr, buffer(39,6))	
	datatree:add(message_status, buffer(45,2))
  else
    subtree:add(message_proto_version, buffer(0,1))
	  local type = buffer(1,1):uint()
	  local type_name = get_type_name(type)
	  subtree:add(message_type, buffer(1,1)):append_text(" (" .. type_name .. ")")
	  -- subtree:add(message_type, buffer(1,1))

	  subtree:add(message_segment, buffer(2,2))
	  if (type_name == "READ" or type_name == "WRITE" or type_name == "DATA") then
		  subtree:add(message_lenght, buffer(4,2))
		  local category = buffer(6,1):uint()
		  local category_name = get_category_name(category)
		  subtree:add(message_category, buffer(6,1)):append_text(" (" .. category_name .. ")")
		  local command = buffer(7,1):uint()
		  if category_name == "NETWORK" then
			command_name = get_network_command_name(command)
			if command < 0x80 then
				subtree:add(message_command, buffer(7,1)):append_text(" (" .. command_name .. ")")
			else
				subtree:add(message_config, buffer(7,1)):append_text(" (" .. command_name .. ")")
			end
			if type_name == "DATA" or type_name == "WRITE" then
				local datatree = subtree:add(motec_protocol, buffer(), "Data")
				if command == 0 or command == 1 then												-- IP-Address and IP-Streaming and
					datatree:add(message_ip_addr, buffer(8,4))
				elseif command == 2 then															-- Streaming port
					datatree:add(message_stream_port, buffer(8,2))
				elseif command == 3 then															-- Codec
					if buffer(8,2):uint() == 0 then
						datatree:add(message_stream_type, buffer(8,2)):append_text(" (MJPG) ")
					else 
						datatree:add(message_stream_type, buffer(8,2)):append_text(" (H.264) ")
					end
				elseif command == 4 or command == 0x84 then  										   -- H.264 compression
					datatree:add(message_h264_compression_cqp, buffer(8,2))
					datatree:add(message_h264_compression_vbr, buffer(10,2))
				elseif command == 5 or command == 0x85 then															-- MJPG compression
					datatree:add(message_mjpg_compression_q, buffer(8,2))			
					datatree:add(message_mjpg_compression_cbr, buffer(10,2))			
				elseif command == 6 or command == 0x86 then															-- Resolution
					datatree:add(message_resolution_x, buffer(8,2))			
					datatree:add(message_resolution_y, buffer(10,2))			
				elseif command == 7 or command == 0x87 then															-- Framerate
					datatree:add(message_fps, buffer(8,2))			
				elseif command == 8 or command == 0x88 then															-- Cropping
					datatree:add(message_resolution_x, buffer(8,2))			
					datatree:add(message_resolution_y, buffer(10,2))			
					datatree:add(message_resolution_width, buffer(12,2))			
					datatree:add(message_resolution_height, buffer(14,2))			
				elseif command == 9 or command == 0x89 then	 										-- Stream
					if buffer(8,2):uint() == 0 then
						datatree:add(message_stream_on_off, buffer(8,2)):append_text(" (OFF) ")
					else 
						datatree:add(message_stream_on_off, buffer(8,2)):append_text(" (ON) ")
					end						
				elseif command == 10 or command == 0x8A then										-- Resolution + Cropping atomar
					datatree:add(message_resolution_x, buffer(8,2))			
					datatree:add(message_resolution_y, buffer(10,2))			
					datatree:add(message_resolution_x, buffer(12,2))			
					datatree:add(message_resolution_y, buffer(14,2))			
					datatree:add(message_resolution_width, buffer(16,2))			
					datatree:add(message_resolution_height, buffer(18,2))			
				elseif command == 11 then															-- MAC address
					datatree:add(message_mac_addr, buffer(8,6))			
				elseif command == 12 then															-- DHCP	
					if buffer(8,2):uint() == 0 then
						datatree:add(message_dhcp, buffer(8,2)):append_text(" (OFF) ")
					else 
						datatree:add(message_dhcp, buffer(8,2)):append_text(" (ON) ")
					end			
				elseif command == 13 then															-- Subnetmask	
					datatree:add(message_subnet_mask, buffer(8,4))	
				end	
			end
		  elseif category_name == "SYSTEM" then
			command_name = get_system_command_name(command)
			subtree:add(message_command, buffer(7,1)):append_text(" (" .. command_name .. ")")
			if type_name == "DATA" or type_name == "WRITE" then
				local datatree = subtree:add(motec_protocol, buffer(), "Data")
				if command == 3  then												-- Camera name
					datatree:add(message_cam_name, buffer(8,32))
				elseif command == 4  then											-- Camera serial
					datatree:add(message_cam_serial, buffer(8,11))					
				elseif command == 5  then											-- Camera article
					datatree:add(message_cam_article, buffer(8,10))					
				elseif command == 6  then											-- Camera software version
					datatree:add(message_cam_sw_version, buffer(8,29))					
				elseif command == 7  then											-- Camera bootloader version
					datatree:add(message_cam_bootloader_version, buffer(8,4))			
				elseif command == 8 then											-- Protocol version
					datatree:add(message_cam_protocol_version, buffer(8,1))								
				elseif command == 0x89 or command == 9 then					-- Heartbeat settings
					datatree:add(message_cam_heartbeat_interval, buffer(8,2))				
					datatree:add(message_cam_heartbeat_destination_IP, buffer(10,4))				
					datatree:add(message_cam_heartbeat_destination_Port, buffer(14,2))				

				elseif command == 0x8A then
					datatree:add(message_cam_isp_register_address, buffer(8,2))	-- Transparent register access of the ISP
					datatree:add(message_cam_isp_register_type, buffer(10,1))
					datatree:add(message_cam_isp_register_value, buffer(11,4))
				end
			end
		  elseif category_name == "FUNCTION" then
			command_name = get_function_command_name(command)
			subtree:add(message_command, buffer(7,1)):append_text(" (" .. command_name .. ")")
			if type_name == "DATA" or type_name == "WRITE" then
				local datatree = subtree:add(motec_protocol, buffer(), "Data")
				if command == 0 or command == 0x80 then								-- Mirroring
					datatree:add(message_mirror_h, buffer(8,1))
					datatree:add(message_mirror_v, buffer(9,1))
				elseif command == 1 or command == 0x81 then							-- Monocrome
					datatree:add(message_monocrome, buffer(8,2))				
				elseif command == 2 or command == 0x82 then							-- Contrast
					datatree:add(message_contrast, buffer(8,2))					
				elseif command == 3 or command == 0x83 then							-- Brightness
					datatree:add(message_brightness, buffer(8,2))					
				elseif command == 4 or command == 0x84 then							-- Sharpness
					datatree:add(message_sharpness, buffer(8,2))					
				end
			end
		  elseif category_name == "APPLICATION (Krone LRE)" then
			command_name = get_application_krone_command_name(command and 0x7F)
			subtree:add(message_command, buffer(7,1)):append_text(" (" .. command_name .. ")")
			
			if type_name == "DATA" then
				local datatree = subtree:add(motec_protocol, buffer(), "Data")
				if command == 0  then												-- Mirroring
					--datatree:add(message_mirror_h, buffer(8,1))
					--datatree:add(message_mirror_v, buffer(9,1))
				elseif command == 1  then											-- Monocrome
					--datatree:add(message_monocrome, buffer(8,2))					
				end
			end
			
		  end
		end
		if (type_name == "ERROR") then
		  subtree:add(message_lenght, buffer(4,2))
		  local error_no = buffer(6,2):uint()
		  local error_name = get_error_name(error_no)
		  subtree:add(message_error, buffer(6,2)):append_text(" (" .. error_name .. ")")
		end
	end
end

local udp_port = DissectorTable.get("udp.port")
udp_port:add(8885, motec_protocol)

function get_type_name(type)
  local type_name = "Unknown"

      if type == 1 then type_name = "READ"
  elseif type == 2 then type_name = "WRITE"
  elseif type == 3 then type_name = "DATA"
  elseif type == 4 then type_name = "ACK"
  elseif type == 5 then type_name = "ERROR"
  elseif type == 6 then type_name = "HEARTBEAT" end

  return type_name
end

function get_error_name(error_no)
  local error_name = "Unknown"

      if error_no == 0 then error_name = "NO_ERROR"
  elseif error_no == 1 then error_name = "TYPE Unknown"
  elseif error_no == 2 then error_name = "CMD/CFG Unknown"
  elseif error_no == 3 then error_name = "CATEGORY Unknown"
  elseif error_no == 4 then error_name = "DATA Unknown"
  elseif error_no == 5 then error_name = "Wrong protocol version"
  elseif error_no == 6 then error_name = "Parameter error"
  elseif error_no == 7 then error_name = "Access error"
  elseif error_no == 8 then error_name = "Sequence error"
  elseif error_no == 9 then error_name = "Lenght error"
  elseif error_no == 10 then error_name = "ISP error"
  end

  return error_name
end

function get_category_name(category)
  local category_name = "Unknown"

      if category == 0 then category_name = "NETWORK"
  elseif category == 1 then category_name = "SYSTEM"
  elseif category == 2 then category_name = "FUNCTION"
  elseif category == 0x10 then category_name = "APPLICATION (Krone LRE)"end

  return category_name
end

function get_network_command_name(command)
  local command_name = "Unknown"

      if command == 0 then command_name = "IP-Address"
  elseif command == 1 then command_name = "IP-Streaming address"
  elseif command == 2 then command_name = "Streaming port"
  elseif command == 3 then command_name = "Stream type"
  elseif command == 4 or command == 0x84 then command_name = "H.264 compression"
  elseif command == 5 or command == 0x85 then command_name = "MJPG compression"
  elseif command == 6 or command == 0x86 then command_name = "Resolution"
  elseif command == 7 or command == 0x87 then command_name = "Framerate"
  elseif command == 8 or command == 0x88 then command_name = "Cropping"
  elseif command == 9 or command == 0x89 then command_name = "Streaming"
  elseif command == 10 or command == 0x8A then command_name = "Resolution + Cropping (atom)"
  elseif command == 11 then command_name = "MAC address (RO)"
  elseif command == 12 then command_name = "DHCP"
  elseif command == 13 then command_name = "Subnetmask" end  
  return command_name
end

function get_system_command_name(command)
  local command_name = "Unknown"

      if command == 0x80 then command_name = "Reset (WO)"
  elseif command == 0x81 then command_name = "Factory default (WO)"
  elseif command == 0x82 then command_name = "Switch to bootloader (WO)"
  elseif command == 3 then command_name = "Camera name"
  elseif command == 4 then command_name = "Camera serial number (RO)"
  elseif command == 5 then command_name = "Camera article number (RO)"
  elseif command == 6 then command_name = "Software version (RO)"
  elseif command == 7 then command_name = "Bootloader version (RO)" 
  elseif command == 8 then command_name = "Protocol version (RO)" 
  elseif command == 0x89 then command_name = "Heartbeat Settings"
  elseif command == 0x8a then command_name = "Transparent register access of the ISP" end
  
  return command_name
end

function get_function_command_name(command)
  local command_name = "Unknown"

      if command == 0 or command == 0x80 then command_name = "Mirroring"
  elseif command == 1 or command == 0x81 then command_name = "Monocrome" 
  elseif command == 2 or command == 0x82 then command_name = "Contrast" 
  elseif command == 3 or command == 0x83 then command_name = "Brightness" 
  elseif command == 4 or command == 0x84 then command_name = "Sharpness" 
  elseif command == 5 or command == 0x85 then command_name = "Auto AE Zone Weights" end
  
  return command_name
end

function get_application_command_name(command)
  local command_name = "Unknown"

      if command == 0 then command_name = "Start calculation of allocation map"
  elseif command == 1 then command_name = "Get allocation map" end
  
  return command_name
end