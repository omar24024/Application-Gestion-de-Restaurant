// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Restaurant App';

  @override
  String get menu => 'Menu';

  @override
  String get cart => 'Mon panier';

  @override
  String get myCart => 'Mon panier';

  @override
  String get orders => 'Mes commandes';

  @override
  String get myOrders => 'Mes commandes';

  @override
  String get login => 'Se connecter';

  @override
  String get register => 'S\'inscrire';

  @override
  String get email => 'Email';

  @override
  String get password => 'Mot de passe';

  @override
  String get fullName => 'Nom complet';

  @override
  String get order => 'Commander';

  @override
  String get total => 'Total';

  @override
  String get accept => 'Accepter';

  @override
  String get refuse => 'Refuser';

  @override
  String get noOrders => 'Aucune commande';

  @override
  String get cartEmpty => 'Panier vide';

  @override
  String get noAccount => 'Pas de compte ? S\'inscrire';

  @override
  String get added => 'ajouté !';

  @override
  String get french => 'Français';

  @override
  String get english => 'English';

  @override
  String get confirmOrder => 'Confirmer la commande';

  @override
  String get confirmOrderQuestion => 'Voulez-vous confirmer votre commande ?';

  @override
  String get cancel => 'Annuler';

  @override
  String get confirm => 'Confirmer';

  @override
  String get orderSent => 'Commande envoyée !';

  @override
  String get restaurantProcessing => 'Le restaurant va traiter votre commande.';

  @override
  String get viewMyOrders => 'Voir mes commandes';

  @override
  String get orderError => 'Erreur lors de la commande. Réessayez !';

  @override
  String get sendingInProgress => 'Envoi en cours...';

  @override
  String get orderNumber => 'Commande #';

  @override
  String get addToCart => 'Ajouter';

  @override
  String get logout => 'Déconnexion';

  @override
  String get locationSent => 'Localisation envoyée';

  @override
  String get locationNotAvailable => 'GPS non disponible';

  @override
  String get payOnDelivery => 'Paiement à la livraison';

  @override
  String get gpsSent => 'GPS sera envoyé';

  @override
  String get accountCreated => 'Compte créé ! Connectez-vous.';

  @override
  String get addDish => 'Ajouter un plat';

  @override
  String get editDish => 'Modifier le plat';

  @override
  String get tapToChooseImage => 'Appuyer pour choisir une image';

  @override
  String get dishName => 'Nom du plat';

  @override
  String get description => 'Description';

  @override
  String get priceDA => 'Prix (DA)';

  @override
  String get add => 'Ajouter';

  @override
  String get edit => 'Modifier';

  @override
  String get menuManagement => 'Gestion du menu';

  @override
  String get noDishesAddSome => 'Aucun plat — ajoutez-en !';

  @override
  String get deleteQuestion => 'Supprimer ?';

  @override
  String deleteConfirm(String name) {
    return 'Supprimer \"$name\" ?';
  }

  @override
  String get delete => 'Supprimer';

  @override
  String get orderDetails => 'Détails Commande #';

  @override
  String get deliveryInformation => 'Informations de livraison';

  @override
  String get positionNotAvailable => 'Position non disponible';

  @override
  String get orderedItems => 'Articles commandés';

  @override
  String get noItems => 'Aucun article';

  @override
  String get unknownDish => 'Plat inconnu';

  @override
  String get quantity => 'Quantité:';

  @override
  String get history => 'Historique';

  @override
  String get pendingOrders => 'Commandes en attente';

  @override
  String get all => 'Toutes';

  @override
  String get accepted => 'Acceptées';

  @override
  String get refused => 'Refusées';

  @override
  String get noOrdersInHistory => 'Aucune commande';

  @override
  String get noPendingOrders => 'Aucune commande en attente';

  @override
  String get acceptedStatus => 'Acceptée';

  @override
  String get refusedStatus => 'Refusée';

  @override
  String get pendingStatus => 'En attente';

  @override
  String get unknown => 'Inconnu';

  @override
  String get gpsAvailable => 'GPS disponible';

  @override
  String get statistics => 'Statistiques';

  @override
  String get totalRevenue => 'Revenu total';

  @override
  String get totalOrders => 'Total commandes';

  @override
  String get dashboardRestaurant => 'Dashboard Restaurant';

  @override
  String get welcome => 'Bienvenue !';

  @override
  String get restaurant => 'Restaurant';

  @override
  String get pending => 'En attente';

  @override
  String get acceptedOrders => 'Acceptées';

  @override
  String get orderHistory => 'Historique des commandes';

  @override
  String get acceptedAndRefused => 'Acceptées et refusées';

  @override
  String get manageMenu => 'Gestion du menu';

  @override
  String get addEditDeleteDishes => 'Ajouter, modifier, supprimer des plats';

  @override
  String get revenueAndOrders => 'Revenus et commandes';

  @override
  String newOrders(String count) {
    return '$count nouvelle(s) commande(s)';
  }

  @override
  String get noDishAvailable => 'Aucun plat disponible';

  @override
  String get gpsLocationWillBeSent => 'Localisation GPS sera envoyée';

  @override
  String get paymentOnDelivery => 'Paiement à la livraison';
}
