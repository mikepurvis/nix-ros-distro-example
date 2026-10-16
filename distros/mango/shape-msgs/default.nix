
# Copyright 2026 Open Source Robotics Foundation
# Distributed under the terms of the BSD license

{ lib, buildRosPackage, fetchurl, ament-cmake, ament-lint-common, geometry-msgs, rosidl-default-generators, rosidl-default-runtime }:
buildRosPackage {
  pname = "ros-mango-shape-msgs";
  version = "5.10.2-r1";

  src = fetchurl {
    url = "https://github.com/ros2-gbp/common_interfaces-release/archive/release/rolling/shape_msgs/5.10.2-1.tar.gz";
    name = "5.10.2-1.tar.gz";
    sha256 = "c129e9b6e68b1d0858d5bed72168d9fd3eb739add8fa13347295e9d2ff723299";
  };

  buildType = "ament_cmake";
  buildInputs = [ ament-cmake geometry-msgs rosidl-default-generators ];
  checkInputs = [ ament-lint-common ];
  nativeBuildInputs = [ ament-cmake rosidl-default-generators ];
  rosBuildExportDepends = [ geometry-msgs ];
  rosExecDepends = [ geometry-msgs rosidl-default-runtime ];

  meta = {
    description = "A package containing some message definitions which describe geometric shapes.";
    license = with lib.licenses; [ asl20 ];
  };
}
