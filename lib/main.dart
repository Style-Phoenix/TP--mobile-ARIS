class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // 1. Logique Google Sign-In
  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser != null) {
        print("Connecté avec Google: ${googleUser.displayName}");
        // Ici, tu peux naviguer vers la page d'accueil ou stocker les informations
      } else {
        print("Connexion Google annulée.");
      }
    } catch (error) {
      print("Erreur de connexion Google: $error");
    }
  }

  // 2. Logique Facebook Login
  Future<void> _signInWithFacebook() async {
    try {
      final LoginResult result = await FlutterFacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        final AccessToken? accessToken = result.accessToken;
        // On récupère les détails de l'utilisateur si la connexion est réussie
        final userData = await FlutterFacebookAuth.instance.getUserData();
        print("Connecté avec Facebook: ${userData['name']}");
        // Utilise accessToken.token pour l'authentification côté serveur si besoin
      } else if (result.status == LoginStatus.cancelled) {
        print("Connexion Facebook annulée.");
      } else {
        print("Erreur de connexion Facebook: ${result.message}");
      }
    } catch (error) {
      print("Erreur de connexion Facebook: $error");
    }
  }

  // 3. Logique Apple Sign-In
  Future<void> _signInWithApple() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      print("Connecté avec Apple! Identifiant: ${credential.userIdentifier}");
      // credential.identityToken ou credential.authorizationCode
      // contiennent les tokens pour la vérification côté serveur
    } catch (error) {
      print("Erreur de connexion Apple: $error");
    }
  }

  // Le reste du code de build reste le même (tu le copieras depuis l'étape 3)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connexion Sociale'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Connectez-vous avec :',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 30),
            
            // Bouton Google
            ElevatedButton.icon(
              icon: const Icon(Icons.g_mobiledata),
              label: const Text('Google'),
              onPressed: _signInWithGoogle,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                minimumSize: const Size(250, 50),
              ),
            ),
            const SizedBox(height: 15),

            // Bouton Facebook
            ElevatedButton.icon(
              icon: const Icon(Icons.facebook),
              label: const Text('Facebook'),
              onPressed: _signInWithFacebook,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade800,
                foregroundColor: Colors.white,
                minimumSize: const Size(250, 50),
              ),
            ),
            const SizedBox(height: 15),

            // Bouton Apple (iCloud) - n'apparaîtra que sur iOS/macOS
            if (Theme.of(context).platform == TargetPlatform.iOS || Theme.of(context).platform == TargetPlatform.macOS)
            ElevatedButton.icon(
              icon: const Icon(Icons.apple),
              label: const Text('Apple / iCloud'),
              onPressed: _signInWithApple,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                minimumSize: const Size(250, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}