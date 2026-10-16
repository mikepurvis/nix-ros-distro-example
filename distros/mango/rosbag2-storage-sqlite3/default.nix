
# Copyright 2026 Open Source Robotics Foundation
# Distributed under the terms of the BSD license

{ lib, buildRosPackage, fetchurl, ament-cmake, ament-cmake-gmock, ament-cmake-python, ament-cmake-ros-core, ament-lint-auto, ament-lint-common, pluginlib, rcpputils, rcutils, rosbag2-storage, rosbag2-test-common, sqlite, std-msgs, yaml-cpp }:
buildRosPackage {
  pname = "ros-mango-rosbag2-storage-sqlite3";
  version = "0.35.0-r1";

  src = fetchurl {
    url = "https://github.com/ros2-gbp/rosbag2-release/archive/release/rolling/rosbag2_storage_sqlite3/0.35.0-1.tar.gz";
    name = "0.35.0-1.tar.gz";
    sha256 = "99ed9bf6d2899a763d0460b68664de830fecd06cce25e73f069b6ed676776121";
  };

  buildType = "ament_cmake";
  buildInputs = [ ament-cmake ament-cmake-python ament-cmake-ros-core pluginlib rcpputils rcutils rosbag2-storage ];
  checkInputs = [ ament-cmake-gmock ament-lint-auto ament-lint-common rosbag2-test-common std-msgs ];
  propagatedBuildInputs = [ sqlite yaml-cpp ];
  nativeBuildInputs = [ ament-cmake ament-cmake-python ament-cmake-ros-core ];
  rosBuildExportDepends = [ pluginlib rcpputils rcutils rosbag2-storage ];
  rosExecDepends = [ pluginlib rcpputils rcutils rosbag2-storage ];

  meta = {
    description = "ROSBag2 SQLite3 storage plugin";
    license = with lib.licenses; [ asl20 ];
  };
}
