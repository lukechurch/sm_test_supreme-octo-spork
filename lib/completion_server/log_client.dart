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
  for (int i = 0; i < 100000; i++)  {
    await info("test", "=====================================");
    await new Future.delayed(new Duration(milliseconds: 5000));
  }
}

const LogTarget TARGET = LogTarget.LOG_SERVER;
const int LOG_SERVER_PORT = 9991;

Future info(String srcName, String logItem) async {
  int i = 0;

  String logLine = "${new DateTime.now().toIso8601String()}: $srcName: $logItem";
  // logLine = logLine.substring(0, logLine.length > 100 ? 100 : logLine.length);
  switch (TARGET) {
    case LogTarget.STDOUT:
      print (logLine);
      break;
    case LogTarget.LOG_SERVER:
      return new HttpClient().post(
        InternetAddress.LOOPBACK_IP_V4.host, LOG_SERVER_PORT, '/').then((req) {
          req.write(logLine);
          return req.flush().then((_) {
            return req.close();
          });
        });
  }
}
