{pkgs, inputs, ...}:
{
  labgrid = pkgs.callPackage ./labgrid { inputs = inputs; };
  umpf = pkgs.callPackage ./umpf {};
  ptx_dev_tools = pkgs.callPackage ./ptx_dev_tools {};
}
