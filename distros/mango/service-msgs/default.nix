
# Copyright 2026 Open Source Robotics Foundation
# Distributed under the terms of the BSD license

{ lib, buildRosPackage, fetchurl, ament-cmake, ament-lint-auto, ament-lint-common, builtin-interfaces, rosidl-core-generators, rosidl-core-runtime }:
buildRosPackage {
  pname = "ros-mango-service-msgs";
  version = "2.5.1-r1";

  src = fetchurl {
    url = "https://github.com/ros2-gbp/rcl_interfaces-release/archive/release/rolling/service_msgs/2.5.1-1.tar.gz";
    name = "2.5.1-1.tar.gz";
    sha256 = "3718f33d495a56ffe28fb0584439c10751c81593a02dc02307ed89dcdb073d38";
  };

  buildType = "ament_cmake";
  buildInputs = [ ament-cmake builtin-interfaces rosidl-core-generators ];
  checkInputs = [ ament-lint-auto ament-lint-common ];
  nativeBuildInputs = [ ament-cmake rosidl-core-generators ];
  rosBuildExportDepends = [ builtin-interfaces rosidl-core-runtime ];
  rosExecDepends = [ builtin-interfaces rosidl-core-runtime ];

  meta = {
    description = "Messages definitions common among all ROS services";
    license = with lib.licenses; [ asl20 ];
  };
}
