import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

typedef Fetcher<T> = Future<T> Function(int userId);

class FetchResult<T> {
  final bool loading;
  final T data;

  FetchResult({
    required this.loading,
    required this.data,
  });
}

FetchResult<T> useFetchWithUser<T>({
  required BuildContext context,
  required int? userId,
  required T initialData,
  required Fetcher<T> fetcher,
  void Function(Object error)? onError,
}) {
  final loading = useState(true);
  final data = useState<T>(initialData);

  useEffect(() {
    if (userId == null) return null;

    () async {
      try {
        final result = await fetcher(userId);
        data.value = result;
      } catch (e) {
        onError?.call(e);
      } finally {
        loading.value = false;
      }
    }();

    return null;
  }, [userId]);

  return FetchResult(
    loading: loading.value,
    data: data.value,
  );
}
