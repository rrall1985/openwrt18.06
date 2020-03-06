-- Licensed to the public under the GNU General Public License v3.

local m, s, o
local shadowsocksr = "shadowsocksr"

local uci = luci.model.uci.cursor()
local server_count = 0
uci:foreach("shadowsocksr", "servers", function(s)
  server_count = server_count + 1
end)

local fs  = require "nixio.fs"
local sys = require "luci.sys"

m = Map(shadowsocksr)
m:section(SimpleSection).template  = "shadowsocksr/status"


-- [[ Servers Manage ]]--
s = m:section(TypedSection, "servers")
s.anonymous = true
s.addremove = true
s.description = string.format(translate("Server Count") ..  ": %d", server_count)
s.sortable = false
s.template = "cbi/tblsection"
s.sortable = true
s.extedit = luci.dispatcher.build_url("admin/services/shadowsocksr/servers/%s")
function s.create(...)
	local sid = TypedSection.create(...)
	if sid then
		luci.http.redirect(s.extedit % sid)
	return
	end
end

o = s:option(DummyValue, "type", translate("Type"))
function o.cfgvalue(...)
	return Value.cfgvalue(...) or translate("")
end

o = s:option(DummyValue, "alias", translate("Alias"))
function o.cfgvalue(...)
	return Value.cfgvalue(...) or translate("None")
end

o = s:option(DummyValue, "server", translate("Server Address"))
function o.cfgvalue(...)
	return Value.cfgvalue(...) or "?"
end

o = s:option(DummyValue, "server_port", translate("Server Port"))
function o.cfgvalue(...)
	return Value.cfgvalue(...) or "?"
end

o = s:option(Flag, "switch_enable", translate("Auto Switch"))
function o.cfgvalue(...)
	return Value.cfgvalue(...) or "1"
end

o = s:option(DummyValue, "server_port", translate("Socket Connected"))
o.template="shadowsocksr/socket"
o.width="10%"

o = s:option(DummyValue, "server", translate("Ping Latency"))
o.template="shadowsocksr/ping"
o.width="10%"

m:append(Template("shadowsocksr/server_list"))

return m
