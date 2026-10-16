
# Copyright 2026 Open Source Robotics Foundation
# Distributed under the terms of the BSD license

{ lib, buildRosPackage, fetchurl, cmake, console-bridge, console-bridge-vendor, python3, tinyxml-2, urdfdom-headers }:
buildRosPackage {
  pname = "ros-mango-urdfdom";
  version = "6.0.1-r1";

  src = fetchurl {
    url = "https://github.com/ros2-gbp/urdfdom-release/archive/release/rolling/urdfdom/6.0.1-1.tar.gz";
    name = "6.0.1-1.tar.gz";
    sha256 = "b9df975a241a490f092119a4feaa64154826ede5014afc801d0e69fdfb6cd11a";
  };

  buildType = "cmake";
  buildInputs = [ cmake console-bridge-vendor urdfdom-headers ];
  checkInputs = [ python3 ];
  propagatedBuildInputs = [ console-bridge tinyxml-2 ];
  nativeBuildInputs = [ cmake ];
  rosBuildExportDepends = [ console-bridge-vendor urdfdom-headers ];
  rosExecDepends = [ console-bridge-vendor urdfdom-headers ];

  meta = {
    description = "A library to access URDFs using the DOM model.";
    license = with lib.licenses; [ bsdOriginal ];
  };
}
