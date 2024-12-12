
#pragma once

#include <zeek/plugin/Plugin.h>

namespace plugin {
namespace Storage_Nats {

class Plugin : public zeek::plugin::Plugin
{
protected:
	// Overridden from zeek::plugin::Plugin.
	zeek::plugin::Configuration Configure() override;
};

extern Plugin plugin;

}
}
