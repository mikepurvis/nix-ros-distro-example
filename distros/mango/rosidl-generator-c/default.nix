
# Copyright 2026 Open Source Robotics Foundation
# Distributed under the terms of the BSD license

{ lib, buildRosPackage, fetchurl, ament-cmake, ament-cmake-core, ament-cmake-python, ament-cmake-ros-core, ament-index-python, ament-lint-auto, ament-lint-common, python3, rcutils, rosidl-cli, rosidl-cmake, rosidl-generator-type-description, rosidl-parser, rosidl-pycommon, rosidl-typesupport-interface }:
buildRosPackage {
  pname = "ros-mango-rosidl-generator-c";
  version = "5.3.1-r2";

  src = fetchurl {
    url = "https://github.com/ros2-gbp/rosidl-release/archive/release/rolling/rosidl_generator_c/5.3.1-2.tar.gz";
    name = "5.3.1-2.tar.gz";
    sha256 = "b15e96e55e96c1b9f6a58d2a68e36c79fd70bcec783350712cc500dc454c8353";
  };

  buildType = "ament_cmake";
  buildInputs = [ ament-cmake ament-cmake-python ament-cmake-ros-core ];
  checkInputs = [ ament-lint-auto ament-lint-common ];
  propagatedBuildInputs = [ python3 ];
  nativeBuildInputs = [ ament-cmake ament-cmake-python ament-cmake-ros-core python3 ];
  rosBuildExportDepends = [ ament-cmake-core rcutils rosidl-cmake rosidl-generator-type-description rosidl-pycommon rosidl-typesupport-interface ];
  rosExecDepends = [ ament-index-python rcutils rosidl-cli rosidl-generator-type-description rosidl-parser ];

  meta = {
    description = "Generate the ROS interfaces in C.";
    license = with lib.licenses; [ asl20 ];
  };
}
