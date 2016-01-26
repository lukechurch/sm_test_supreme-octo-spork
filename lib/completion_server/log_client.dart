// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library smart.completion_server.log_client;

import 'dart:io';
import 'dart:async';


enum LogTarget {
  LOG_SERVER,
  STDOUT
}

main(List<String> args) async {
  for (int i = 0; i < 100; i++)  await info("test", "Test line");
}

const LogTarget TARGET = LogTarget.LOG_SERVER;
const int LOG_SERVER_PORT = 9991;

Future info(String srcName, String logItem) async {
  int i = 0;

  print (i++);
  String logLine = "${new DateTime.now().toIso8601String()}: $srcName: $logItem";
  print (i++);
  switch (TARGET) {
    case LogTarget.STDOUT:
      print (logLine);
      break;
    case LogTarget.LOG_SERVER:
    print (i++);
      return new HttpClient().post(
        InternetAddress.LOOPBACK_IP_V4.host, LOG_SERVER_PORT, '/').then((req) {
          print (i++);
          req.write(logLine);
          print (i++);
          return req.close();
        });
  }
}
