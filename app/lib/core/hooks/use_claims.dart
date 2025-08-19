import 'package:app/core/components/alert.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../services/auth_service.dart'; // adjust your path

Map<String, dynamic> useClaimsHook(context) {
  final claims = useState<Map<String, dynamic>>({});

  useEffect(() {
    void fetchData() async {
      try {
        final data = await AuthService.getClaims();
        claims.value = data;
      } catch (e) {
        if (!context.mounted) return;
        showAlertError(
          context,
          "Failed to fetch user credential please logout and re-login."
        );
      }
    }

    fetchData();
    return null;
  }, []);

  return claims.value;
}
