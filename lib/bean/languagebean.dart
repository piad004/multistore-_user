
class LanguageCode{
  String langCode;
  String langString;

  LanguageCode(this.langCode, this.langString);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LanguageCode &&
          runtimeType == other.runtimeType &&
          (langCode == other.langCode || langString == other.langString);

  @override
  int get hashCode => langCode.hashCode;
}