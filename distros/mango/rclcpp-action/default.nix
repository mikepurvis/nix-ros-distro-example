
# Copyright 2026 Open Source Robotics Foundation
# Distributed under the terms of the BSD license

{ lib, buildRosPackage, fetchurl, action-msgs, ament-cmake-gtest, ament-cmake-ros, ament-cmake-ros-core, ament-lint-auto, ament-lint-common, mimick-vendor, performance-test-fixture, rcl, rcl-action, rclcpp, rcpputils, rosidl-runtime-c, test-msgs }:
buildRosPackage {
  pname = "ros-mango-rclcpp-action";
  version = "33.1.0-r1";

  src = fetchurl {
    url = "https://github.com/ros2-gbp/rclcpp-release/archive/release/rolling/rclcpp_action/33.1.0-1.tar.gz";
    name = "33.1.0-1.tar.gz";
    sha256 = "66a2e5a10327975729c1a04e8fb7a2d91e9aaab4074c88e5fc13a8b7d7ad8aaa";
  };

  buildType = "ament_cmake";
  buildInputs = [ action-msgs ament-cmake-ros ament-cmake-ros-core rcl rcl-action rclcpp rcpputils rosidl-runtime-c ];
  checkInputs = [ ament-cmake-gtest ament-lint-auto ament-lint-common mimick-vendor performance-test-fixture test-msgs ];
  nativeBuildInputs = [ ament-cmake-ros ];
  rosBuildExportDepends = [ action-msgs rcl rcl-action rclcpp rcpputils rosidl-runtime-c ];
  rosExecDepends = [ action-msgs rcl rcl-action rclcpp rcpputils ];

  meta = {
    description = "Adds action APIs for C++.";
    license = with lib.licenses; [ asl20 ];
  };
}
