enum AdCategory {
  basic,
  mix,
}

enum AdViewType {
  banner("Banner", [13450]),
  popup("Popup", [13994]),
  inPage("InPage", [13691]),
  welcome("Welcome", [14028]),
  catfish("Catfish", [13991]),
  home("Home", [19217]),
  list("List", [13450, 19325, 14028,19326,19327,19328,19329]),
  stickyList("StickyList", [13450,13450, 19325, 19326,19327,19328,19329]);

  final String label;
  final List<int> ids;

  const AdViewType(this.label, this.ids);
}

class AdItem {
  final int id;
  final AdViewType type;
  final AdCategory category;

  AdItem({
    required this.id,
    required this.type,
    required this.category,
  });
}
