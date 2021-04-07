class FAQItem {
  FAQItem(this.header,this.expandedBody, {this.isExpanded = false});

  String header;
  String expandedBody;
  bool isExpanded;
}