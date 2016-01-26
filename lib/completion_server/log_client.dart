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

info(String srcName, String logItem) async {
  String logLine = "${new DateTime.now().toIso8601String()}: $srcName: $logItem";
  switch (TARGET) {
    case LogTarget.STDOUT:
      print (logLine);
      break;
    case LogTarget.LOG_SERVER:
      var request = await new HttpClient().post(
        InternetAddress.LOOPBACK_IP_V4.host, LOG_SERVER_PORT, '/');
      request.write(logLine);
      await request.close();
      break;
  }
}
