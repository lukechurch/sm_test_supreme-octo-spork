// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library smart.completion_server.log_client;

import 'dart:io';

enum LogTarget {
  LOG_SERVER,
  STDOUT
}

const LogTarget TARGET = LogTarget.LOG_SERVER;
const int LOG_SERVER_PORT = 9991;

info(String s) async {
  switch (TARGET) {
    case LogTarget.STDOUT:
      print ("${new DateTime.now().toIso8601String()}: $s");
      break;
    case LogTarget.LOG_SERVER:
      var request = await new HttpClient().post(
        InternetAddress.LOOPBACK_IP_V4.host, LOG_SERVER_PORT, '/');
      request.write(s);
      await request.close();
      break;
  }
}
