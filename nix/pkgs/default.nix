pkgs:
let inherit (pkgs) callPackage; in
{
  prettier-plugin-go-template = (
    callPackage ./development/node-packages { }
  )."prettier-plugin-go-template-0.0.15";
}
