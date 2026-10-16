
# Copyright 2026 Open Source Robotics Foundation
# Distributed under the terms of the BSD license

{ lib, buildRosPackage, fetchurl, ament-cmake, ament-lint-common, builtin-interfaces, rosidl-default-generators, rosidl-default-runtime }:
buildRosPackage {
  pname = "ros-mango-std-msgs";
  version = "5.10.2-r1";

  src = fetchurl {
    url = "https://github.com/ros2-gbp/common_interfaces-release/archive/release/rolling/std_msgs/5.10.2-1.tar.gz";
    name = "5.10.2-1.tar.gz";
    sha256 = "54a475b787b5a595602bc3ab2fb445f9c82cfa155390a677b5702ee406871cf5";
  };

  buildType = "ament_cmake";
  buildInputs = [ ament-cmake builtin-interfaces rosidl-default-generators ];
  checkInputs = [ ament-lint-common ];
  nativeBuildInputs = [ ament-cmake rosidl-default-generators ];
  rosBuildExportDepends = [ builtin-interfaces ];
  rosExecDepends = [ builtin-interfaces rosidl-default-runtime ];

  meta = {
    description = "A package containing some standard message definitions.";
    license = with lib.licenses; [ asl20 ];
  };
}
