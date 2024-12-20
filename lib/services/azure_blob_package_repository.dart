import 'dart:io';

import 'package:azblob/azblob.dart';
import 'package:nel/services/package_repository.dart';

class AzureBlobPackageRepository implements PackageRepository{
  static const connectionStringVarName = "MICROSOFT_BLOB_CONNECTION_STRING";
  late final String connectionString;

  AzureBlobPackageRepository(){
    final maybeConnectionString = Platform.environment[connectionStringVarName];
    assert(maybeConnectionString != null);
    connectionString = maybeConnectionString!;
  }


  Future<void> writeFile() async {
    var storage = AzureStorage.parse(connectionString);
    await storage.putBlob('/yourcontainer/yourfile.txt',
        body: 'Hello, world.');
  }

}