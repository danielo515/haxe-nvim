package test;

import packer.Packer;
import packer.Macro;

function main() {
  final x:PluginSpec = packer.Macro.plugin({name: "rabo", cmd: "Rabo", culo: true});
  trace(x);
}
