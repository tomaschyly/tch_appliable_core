import 'dart:convert';

import 'package:example/model/http_records.dart';
import 'package:tch_appliable_core/tch_appliable_core.dart';

class GetHttpRecordsDataRequest extends DataRequest<HttpRecords> {
  /// GetHttpRecordsDataRequest initialization
  GetHttpRecordsDataRequest(Map<String, dynamic> parameters)
      : super(
          source: MainDataProviderSource.httpClient,
          method: HttpRecords.method,
          parameters: parameters,
          processResult: (json) {
            final String recordsJson = json['response'] ?? '[]';

            return HttpRecords.fromJson(<String, dynamic>{
              'list': jsonDecode(recordsJson),
            });
          },
          pagination: RequestPagination(
            checkResultNotEmpty: requestPaginationCheckList,
            combinePaginationResult: requestPaginationCombineLists,
          ),
        );
}
