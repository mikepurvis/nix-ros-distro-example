
# Copyright 2026 Open Source Robotics Foundation
# Distributed under the terms of the BSD license

{ lib, buildRosPackage, fetchurl, ament-cmake, ament-cmake-ros-core, ament-index-cpp, ament-lint-auto, ament-lint-common, fastcdr, nlohmann_json, rcpputils, rcutils, rmw, rmw-test-fixture, rosidl-buffer-backend-registry, rosidl-typesupport-fastrtps-c, rosidl-typesupport-fastrtps-cpp, tracetools, zenoh-cpp-vendor }:
buildRosPackage {
  pname = "ros-mango-rmw-zenoh-cpp";
  version = "0.13.0-r1";

  src = fetchurl {
    url = "https://github.com/ros2-gbp/rmw_zenoh-release/archive/release/rolling/rmw_zenoh_cpp/0.13.0-1.tar.gz";
    name = "0.13.0-1.tar.gz";
    sha256 = "11af255a3e7c5ca0cd80443d1c934b08a9bcebd17edb4d56c966ac724d6503ec";
  };

  buildType = "ament_cmake";
  buildInputs = [ ament-cmake ament-cmake-ros-core ament-index-cpp fastcdr nlohmann_json rcpputils rcutils rmw rmw-test-fixture rosidl-buffer-backend-registry rosidl-typesupport-fastrtps-c rosidl-typesupport-fastrtps-cpp tracetools zenoh-cpp-vendor ];
  checkInputs = [ ament-lint-auto ament-lint-common ];
  nativeBuildInputs = [ ament-cmake ament-cmake-ros-core ];
  rosBuildExportDepends = [ ament-cmake-ros-core ament-index-cpp fastcdr rcpputils rcutils rmw rmw-test-fixture rosidl-buffer-backend-registry rosidl-typesupport-fastrtps-c rosidl-typesupport-fastrtps-cpp tracetools zenoh-cpp-vendor ];
  rosExecDepends = [ ament-index-cpp fastcdr rcpputils rcutils rmw rmw-test-fixture rosidl-buffer-backend-registry rosidl-typesupport-fastrtps-c rosidl-typesupport-fastrtps-cpp tracetools zenoh-cpp-vendor ];

  meta = {
    description = "A ROS 2 middleware implementation using zenoh-cpp";
    license = with lib.licenses; [ asl20 bsdOriginal ];
  };
}
