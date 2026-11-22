import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Fractions of a Set is an optional number model in Applied Maths Studio.
/// Its copy is frozen in build brief §6 (five governed locales; en_GB = en)
/// and makes no coverage, stage, mastery, score, game, level, world or
/// collection-identity claim. It wires nothing into the Topic Hub,
/// registries, progress or platform code (brief §7).
void main() {
  const locales = [
    'app_en.arb',
    'app_en_GB.arb',
    'app_de_CH.arb',
    'app_fr_CH.arb',
    'app_it_CH.arb',
  ];
  // Column of the frozen table for each ARB.
  const column = {
    'app_en.arb': 0,
    'app_en_GB.arb': 0,
    'app_de_CH.arb': 1,
    'app_fr_CH.arb': 2,
    'app_it_CH.arb': 3,
  };
  const newSources = [
    'lib/models/fractions_of_a_set/fractions_of_a_set_session.dart',
    'lib/widgets/labs/fractions_of_a_set/fractions_of_a_set_trays.dart',
    'lib/widgets/labs/fractions_of_a_set/fractions_of_a_set_bar.dart',
    'lib/screens/labs/fractions_of_a_set/fractions_of_a_set_screen.dart',
  ];

  // The Pitch Coordinates map, unchanged.
  final existing = <String, RegExp>{
    'key stage':
        RegExp(r'\bks ?[1-5]\b|key stage|schlüsselstufe', caseSensitive: false),
    'GCSE / A-level': RegExp(r'gcse|a[- ]level', caseSensitive: false),
    'curriculum': RegExp(r'curricul|lehrplan|programme scolaire|programma',
        caseSensitive: false),
    'Topic Hub': RegExp(r'topic hub', caseSensitive: false),
    'mastery': RegExp(r'master|mastery|maîtris|padronanza|beherrsch',
        caseSensitive: false),
    'assessment': RegExp(
        r'assess|\bexam|\bquiz|\btest\b|prüfung|évaluation|valutazione|verifica',
        caseSensitive: false),
    'score / points / marks': RegExp(
        r'\bscores?\b|\bpoints?\b|\bmarks?\b|punkte|punteggio|\bnote\b',
        caseSensitive: false),
    'timer': RegExp(r'\btimer|countdown|chrono|stopwatch|minuterie',
        caseSensitive: false),
    'streak / leaderboard':
        RegExp(r'streak|leaderboard|ranking|classement', caseSensitive: false),
    'completion record':
        RegExp(r'\bcomplet(ed|ion)\b|\bsaved progress', caseSensitive: false),
    'Angle Academy': RegExp(
        r'angle academy|academy|akademie|académie|accademia',
        caseSensitive: false),
    'companion app':
        RegExp(r'dino ?polo|football studio|companion', caseSensitive: false),
  };
  // The C-2 patterns, the point-sense pattern and the Fractions-only
  // pattern (brief §7.2).
  final fractionsOnly = <String, RegExp>{
    'game': RegExp(r'\bgames?\b|\bspiel(e)?\b|\bjeux?\b|\bgioc(o|hi)\b',
        caseSensitive: false),
    'level / stage': RegExp(
        r'\blevels?\b|\bniveaux?\b|\blivell[oi]\b|\bstages?\b|\bstufen?\b',
        caseSensitive: false),
    'point sense':
        RegExp(r'\bpoints?\b|\bpunkt|\bpunt[oi]\b', caseSensitive: false),
    'world / collection identity / year / wrong': RegExp(
        r'\bworlds?\b|\bwelt(en)?\b|\bmondes?\b|\bmondo\b|\bdino|football|'
        r'fussball|fußball|calcio|\bpanda|core maths|number models|'
        r'zahlenmodelle|modèles numériques|modelli numerici|\byear ?\d|'
        r'\bjahr ?\d|\bannée ?\d|\banno ?\d|\bwrong\b|\bfalsch\b|\bfaux\b|'
        r'\bsbagliat',
        caseSensitive: false),
  };

  Map<String, dynamic> arb(String f) =>
      jsonDecode(File('lib/l10n/$f').readAsStringSync())
          as Map<String, dynamic>;
  bool isLabKey(String k) =>
      !k.startsWith('@') && k.startsWith('labsFractionsOfASet');

  test('the frozen table has 63 keys', () {
    expect(fosFrozenCopy.length, 63);
    for (final v in fosFrozenCopy.values) {
      expect(v, hasLength(4));
    }
  });

  test('copy freeze: 63 keys (brief §6 + UAT repair), in every governed locale',
      () {
    final expectedKeys = {
      for (final s in fosFrozenCopy.keys) 'labsFractionsOfASet$s',
    };
    for (final f in locales) {
      final data = arb(f);
      expect(data.keys.where(isLabKey).toSet(), expectedKeys, reason: f);
      fosFrozenCopy.forEach((suffix, values) {
        final value = data['labsFractionsOfASet$suffix'] as String;
        expect(value.trim(), isNotEmpty, reason: '$f $suffix');
        expect(value, values[column[f]!], reason: '$f $suffix');
      });
    }
    final meta = arb('app_en.arb')
        .keys
        .where((k) => k.startsWith('@labsFractionsOfASet'));
    expect(meta.length, 63);
  });

  test('the card copy, kind label and correct-answer message', () {
    final en = arb('app_en.arb');
    expect(en['labsFractionsOfASetTitle'], 'Fractions of a Set');
    expect(en['labsFractionsOfASetCardKind'], 'Number model');
    expect(en['labsFractionsOfASetCorrect'], "Yes, that's correct.");
    expect(en['labsFractionsOfASetYes'], "Yes, it's fair");
    expect(en['labsFractionsOfASetNo'], "No, it's not fair");
  });

  test("no forbidden claim appears in any locale's copy", () {
    for (final f in locales) {
      final data = arb(f);
      for (final key in data.keys.where(isLabKey)) {
        final value = data[key] as String;
        for (final MapEntry(key: name, value: pattern)
            in {...existing, ...fractionsOnly}.entries) {
          expect(pattern.hasMatch(value), isFalse,
              reason: '$f $key mentions $name: "$value"');
        }
      }
    }
  });

  test('the control list passes every pattern; banned words are caught', () {
    const spare = [
      'groups',
      'chosen',
      'fair',
      'counters',
      'tray',
      'collection',
      'Number model',
      'Gruppen',
      'Schale',
      'Zahlenmodell',
      'plateau',
      'jetons',
      'équitable',
      'vassoio',
      'gettoni',
      'equa',
      'Modello numerico',
    ];
    const banned = [
      'a game',
      'next level',
      'Football Maths World',
      'Number Models',
      'Zahlenmodelle',
      'modèles numériques',
      'modelli numerici',
      'Year 3',
      'wrong',
      'falsch',
      'sbagliato',
      'Core Maths',
      'panda',
      '3 points',
    ];
    final all = {...existing, ...fractionsOnly}.values;
    for (final w in spare) {
      expect(all.any((p) => p.hasMatch(w)), isFalse, reason: w);
    }
    for (final w in banned) {
      expect(all.any((p) => p.hasMatch(w)), isTrue, reason: w);
    }
  });

  test('ARB descriptions carry no fit, stage, curriculum or collection name',
      () {
    final en = arb('app_en.arb');
    final meta = en.keys.where((k) => k.startsWith('@labsFractionsOfASet'));
    for (final k in meta) {
      final d = jsonEncode(en[k]);
      for (final p in [
        existing['key stage']!,
        existing['GCSE / A-level']!,
        existing['curriculum']!,
        existing['Topic Hub']!,
        RegExp(r'\bstages?\b|pedagogical fit|\bfit\b|coverage',
            caseSensitive: false),
        RegExp('number models', caseSensitive: false),
      ]) {
        expect(p.hasMatch(d), isFalse, reason: '$k: $d');
      }
    }
  });

  test(
      'no companion, progress, curriculum or platform code in new sources '
      '(comments included)', () {
    final forbiddenCode = <String, RegExp>{
      'Angle Academy branding': RegExp(r'angle ?academy', caseSensitive: false),
      'platform channels': RegExp(r'MethodChannel|EventChannel'),
      'deep links / URI launch':
          RegExp(r'Uri\.parse|getInitialLink|uriLinkStream|dinopolo://'),
      'companion app':
          RegExp(r'dino_?polo|Dino Polo|football_studio', caseSensitive: false),
      'persistence': RegExp(
          r'SharedPreferences|\.setBool|\.setString|\.setInt|ProgressService|'
          r'recordCompletion|recordEvent'),
      'key stage / exam claims':
          RegExp(r'\bKS ?[1-5]\b|GCSE|A[- ]level', caseSensitive: false),
      'curriculum / Topic Hub': RegExp(
          r'curriculum|TopicCapability|InteractiveLabId|topicId',
          caseSensitive: false),
    };
    for (final path in newSources) {
      final src = File(path).readAsStringSync();
      forbiddenCode.forEach((name, pattern) {
        expect(pattern.hasMatch(src), isFalse, reason: '$path: $name');
      });
    }
  });

  test('no sentence string literal in the Dart model', () {
    final model = File(newSources.first).readAsStringSync();
    final code = model.replaceAll(RegExp(r'//.*'), '');
    final literals = [
      ...RegExp(r"'(?:[^'\\\n]|\\.)*'").allMatches(code),
      ...RegExp(r'"(?:[^"\\\n]|\\.)*"').allMatches(code),
    ].map((m) => m[0]!).toList();
    for (final literal in literals) {
      expect(RegExp(r'[A-Za-z]{2,}\s+[A-Za-z]{2,}').hasMatch(literal), isFalse,
          reason: 'model holds a sentence literal: $literal');
      for (final word in [
        'counter',
        'group',
        'tray',
        'fraction',
        'collection',
        'correct',
        'fair',
        'Yes',
        'Take',
      ]) {
        expect(literal.toLowerCase().contains(word.toLowerCase()), isFalse,
            reason: 'model holds a "$word" literal: $literal');
      }
    }
    expect(model.contains("import 'package:flutter"), isFalse,
        reason: 'the model is pure Dart');
  });

  test('no image asset, external renderer or engine is used', () {
    for (final path in newSources) {
      final src = File(path).readAsStringSync();
      for (final banned in [
        'Image.asset',
        'AssetImage',
        'Image.network',
        'SvgPicture',
        'package:flutter_scene',
        'package:flame',
        'package:rive',
      ]) {
        expect(src.contains(banned), isFalse, reason: '$path uses $banned');
      }
    }
  });

  test('no Topic Hub, curriculum, registry, progress or platform wiring', () {
    final guarded = [
      'lib/services/topic_capability_resolver.dart',
      'assets/config/curriculum_manifest.json',
      'assets/config/studio_content_registry.json',
      'lib/models/interactive_lab_id.dart',
      'lib/services/interactive_labs_progress_service.dart',
      'android/app/src/main/AndroidManifest.xml',
    ];
    final marker = RegExp(r'fractions[-_ ]?of[-_ ]?a[-_ ]?set|fractionsOfASet',
        caseSensitive: false);
    for (final path in guarded) {
      expect(marker.hasMatch(File(path).readAsStringSync()), isFalse,
          reason: '$path must not reference Fractions of a Set');
    }
    final router = File('lib/app/router.dart').readAsStringSync();
    expect(RegExp("path: 'fractions-of-a-set'").allMatches(router).length, 1,
        reason: 'exactly one route, the child under Applied Maths Studio');
    // The last child of the studio, immediately after Pitch Coordinates.
    final pitch = router.indexOf("path: 'pitch-coordinates'");
    final fos = router.indexOf("path: 'fractions-of-a-set'");
    expect(pitch, greaterThan(0));
    expect(fos, greaterThan(pitch));
    expect(
        router
            .substring(pitch + "path: 'pitch-coordinates'".length, fos)
            .contains('path:'),
        isFalse,
        reason: 'no other route between the two');
    final studioRoute = router.substring(fos);
    final routeBlock = studioRoute.substring(0, studioRoute.indexOf('),'));
    expect(routeBlock.contains('parentNavigatorKey'), isFalse);
  });
}

// Brief §6.2: en (= en_GB), de_CH, fr_CH, it_CH.
const fosFrozenCopy = <String, List<String>>{
  "Title": [
    "Fractions of a Set",
    "Bruchteile einer Menge",
    "Fractions d'une collection",
    "Frazioni di un insieme",
  ],
  "CardSubtitle": [
    "Share a collection into equal groups to find a fraction of it.",
    "Teile eine Sammlung in gleich grosse Gruppen, um einen Bruchteil davon zu finden.",
    "Partage une collection en groupes égaux pour en trouver une fraction.",
    "Dividi una raccolta in gruppi uguali per trovarne una frazione.",
  ],
  "CardKind": [
    "Number model",
    "Zahlenmodell",
    "Modèle numérique",
    "Modello numerico",
  ],
  "Intro": [
    "The bottom number says how many equal groups to make. The top number says how many groups to take.",
    "Die untere Zahl sagt, wie viele gleich grosse Gruppen du bildest. Die obere Zahl sagt, wie viele Gruppen du nimmst.",
    "Le nombre du bas dit combien de groupes égaux former. Le nombre du haut dit combien de groupes prendre.",
    "Il numero in basso dice quanti gruppi uguali formare. Il numero in alto dice quanti gruppi prendere.",
  ],
  "PromptFind": [
    "What is {fraction} of these {total} counters?",
    "Was ist {fraction} von diesen {total} Plättchen?",
    "Combien font {fraction} de ces {total} jetons ?",
    "Quanto fa {fraction} di questi {total} gettoni?",
  ],
  "PromptTransfer": [
    "{fraction} of {total} = ?",
    "{fraction} von {total} = ?",
    "{fraction} de {total} = ?",
    "{fraction} di {total} = ?",
  ],
  "PromptWhat": [
    "{chosen} of these {total} counters are chosen. What fraction of the collection is that?",
    "{chosen} von diesen {total} Plättchen sind gewählt. Welcher Bruchteil der Sammlung ist das?",
    "{chosen} de ces {total} jetons sont choisis. Quelle fraction de la collection est-ce ?",
    "{chosen} di questi {total} gettoni sono scelti. Che frazione della raccolta è?",
  ],
  "PromptCompare": [
    "Which is more: {fractionA} of {total} or {fractionB} of {total}?",
    "Was ist mehr: {fractionA} von {total} oder {fractionB} von {total}?",
    "Lequel est le plus grand : {fractionA} de {total} ou {fractionB} de {total} ?",
    "Che cosa è di più: {fractionA} di {total} o {fractionB} di {total}?",
  ],
  "PromptEqual": [
    "Is this a fair split into {groups} equal groups?",
    "Ist das eine faire Aufteilung in {groups} gleich grosse Gruppen?",
    "Est-ce un partage équitable en {groups} groupes égaux ?",
    "È una divisione equa in {groups} gruppi uguali?",
  ],
  "Prediction": [
    "Your answer",
    "Deine Antwort",
    "Ta réponse",
    "La tua risposta",
  ],
  "ConfirmAnswer": [
    "Confirm my answer",
    "Antwort bestätigen",
    "Confirmer ma réponse",
    "Conferma la mia risposta",
  ],
  "StepGroup": [
    "Make {groups} equal groups. Tap a tray to put a counter in it.",
    "Bilde {groups} gleich grosse Gruppen. Tippe auf eine Schale, um ein Plättchen hineinzulegen.",
    "Forme {groups} groupes égaux. Touche un plateau pour y mettre un jeton.",
    "Forma {groups} gruppi uguali. Tocca un vassoio per metterci un gettone.",
  ],
  "Deal": [
    "Deal one to each tray",
    "In jede Schale eins legen",
    "Un jeton dans chaque plateau",
    "Uno in ogni vassoio",
  ],
  // 2026-11-17 Pixel UAT repair: this per-tray accessible name replaced the
  // generic "Take one out" key, which was then removed.
  "TakeOneOutOfTray": [
    "Take one out of tray {index}",
    "Eins aus Schale {index} herausnehmen",
    "En retirer un du plateau {index}",
    "Togline uno dal vassoio {index}",
  ],
  "StartAgain": [
    "Start again",
    "Neu beginnen",
    "Recommencer",
    "Ricomincia",
  ],
  "LeftToPlace": [
    "{count, plural, =0{Every counter is placed.} =1{1 counter left to place} other{{count} counters left to place}}",
    "{count, plural, =0{Alle Plättchen sind verteilt.} =1{Noch 1 Plättchen zu verteilen} other{Noch {count} Plättchen zu verteilen}}",
    "{count, plural, =0{Tous les jetons sont placés.} =1{Encore 1 jeton à placer} other{Encore {count} jetons à placer}}",
    "{count, plural, =0{Tutti i gettoni sono sistemati.} =1{Ancora 1 gettone da sistemare} other{Ancora {count} gettoni da sistemare}}",
  ],
  "GroupsReady": [
    "These groups are ready",
    "Diese Gruppen sind fertig",
    "Ces groupes sont prêts",
    "Questi gruppi sono pronti",
  ],
  "StepTake": [
    "Take {n} of the {groups} groups. Tap the trays you want.",
    "Nimm {n} der {groups} Gruppen. Tippe auf die Schalen, die du willst.",
    "Prends {n} des {groups} groupes. Touche les plateaux que tu veux.",
    "Prendi {n, plural, =1{1 gruppo} other{{n} gruppi}} su {groups}. Tocca i vassoi che vuoi.",
  ],
  "TakeConfirm": [
    "Take these groups",
    "Diese Gruppen nehmen",
    "Prendre ces groupes",
    "Prendi questi gruppi",
  ],
  "TakeCount": [
    "{n, plural, =1{Take 1 tray.} other{Take {n} trays.}} You have chosen {chosen}.",
    "{n, plural, =1{Nimm 1 Schale.} other{Nimm {n} Schalen.}} Du hast {chosen} gewählt.",
    "{n, plural, =1{Prends 1 plateau.} other{Prends {n} plateaux.}} Tu en as choisi {chosen}.",
    "{n, plural, =1{Prendi 1 vassoio.} other{Prendi {n} vassoi.}} Ne hai scelti {chosen}.",
  ],
  "Tray": [
    "Tray {index} of {groups}: {count, plural, =0{empty} =1{1 counter} other{{count} counters}}",
    "Schale {index} von {groups}: {count, plural, =0{leer} =1{1 Plättchen} other{{count} Plättchen}}",
    "Plateau {index} sur {groups} : {count, plural, =0{vide} =1{1 jeton} other{{count} jetons}}",
    "Vassoio {index} di {groups}: {count, plural, =0{vuoto} =1{1 gettone} other{{count} gettoni}}",
  ],
  "Chosen": [
    "chosen",
    "gewählt",
    "choisi",
    "scelto",
  ],
  "Different": [
    "different",
    "anders",
    "différent",
    "diverso",
  ],
  "Collection": [
    "{count, plural, =0{Collection: empty} =1{Collection: 1 counter to place} other{Collection: {count} counters to place}}",
    "{count, plural, =0{Sammlung: leer} =1{Sammlung: noch 1 Plättchen zu verteilen} other{Sammlung: noch {count} Plättchen zu verteilen}}",
    "{count, plural, =0{Collection : vide} =1{Collection : encore 1 jeton à placer} other{Collection : encore {count} jetons à placer}}",
    "{count, plural, =0{Raccolta: vuota} =1{Raccolta: ancora 1 gettone da sistemare} other{Raccolta: ancora {count} gettoni da sistemare}}",
  ],
  "TopNumber": [
    "Top number",
    "Obere Zahl",
    "Nombre du haut",
    "Numero in alto",
  ],
  "OutOfGroups": [
    "out of {groups} equal groups",
    "von {groups} gleich grossen Gruppen",
    "sur {groups} groupes égaux",
    "su {groups} gruppi uguali",
  ],
  "Same": [
    "They are the same",
    "Sie sind gleich viel",
    "C'est pareil",
    "Sono uguali",
  ],
  "Yes": [
    "Yes, it's fair",
    "Ja, sie ist fair",
    "Oui, le partage est équitable",
    "Sì, è equa",
  ],
  "No": [
    "No, it's not fair",
    "Nein, sie ist nicht fair",
    "Non, le partage n'est pas équitable",
    "No, non è equa",
  ],
  "RevealFind": [
    "{fraction} of {total} is {answer}.",
    "{fraction} von {total} ist {answer}.",
    "{fraction} de {total}, c'est {answer}.",
    "{fraction} di {total} è {answer}.",
  ],
  "RevealSteps": [
    "{total} ÷ {groups} = {size}, then {n} × {size} = {answer}",
    "{total} ÷ {groups} = {size}, dann {n} × {size} = {answer}",
    "{total} ÷ {groups} = {size}, puis {n} × {size} = {answer}",
    "{total} ÷ {groups} = {size}, poi {n} × {size} = {answer}",
  ],
  "RevealWhat": [
    "{chosen} of {total} is {fraction}: {n} of the {groups} equal groups.",
    "{chosen} von {total} sind {fraction}: {n} der {groups} gleich grossen Gruppen.",
    "{chosen} sur {total}, c'est {fraction} : {n} des {groups} groupes égaux.",
    "{chosen} su {total} è {fraction}: {n, plural, =1{1 gruppo uguale} other{{n} gruppi uguali}} su {groups}.",
  ],
  "RevealCompare": [
    "{fractionA} of {total} is {valueA}; {fractionB} of {total} is {valueB}.",
    "{fractionA} von {total} ist {valueA}; {fractionB} von {total} ist {valueB}.",
    "{fractionA} de {total}, c'est {valueA} ; {fractionB} de {total}, c'est {valueB}.",
    "{fractionA} di {total} è {valueA}; {fractionB} di {total} è {valueB}.",
  ],
  "RevealEqual": [
    "{groups} trays with {size} in each.",
    "{groups} Schalen mit je {size}.",
    "{groups} plateaux avec {size} dans chacun.",
    "{groups} vassoi con {size} in ciascuno.",
  ],
  "Correct": [
    "Yes, that's correct.",
    "Ja, das stimmt.",
    "Oui, c'est correct.",
    "Sì, è corretto.",
  ],
  "FbDivNum": [
    "The bottom number, {groups}, says how many equal groups to make. The top number, {n}, says how many of those groups to take.",
    "Die untere Zahl, {groups}, sagt, wie viele gleich grosse Gruppen du bildest. Die obere Zahl, {n}, sagt, wie viele davon du nimmst.",
    "Le nombre du bas, {groups}, dit combien de groupes égaux former. Le nombre du haut, {n}, dit combien de ces groupes prendre.",
    "Il numero in basso, {groups}, dice quanti gruppi uguali formare. Il numero in alto, {n}, dice quanti di quei gruppi prendere.",
  ],
  "FbTookN": [
    "The fraction is of the whole collection, so take whole groups, not single counters.",
    "Der Bruchteil bezieht sich auf die ganze Sammlung. Nimm also ganze Gruppen, nicht einzelne Plättchen.",
    "La fraction porte sur toute la collection : prends des groupes entiers, pas des jetons isolés.",
    "La frazione è di tutta la raccolta: prendi gruppi interi, non singoli gettoni.",
  ],
  "FbOneGroup": [
    "That is one group. The top number says take {n} groups, so count them all.",
    "Das ist eine Gruppe. Die obere Zahl sagt: Nimm {n} Gruppen. Zähle sie alle.",
    "C'est un seul groupe. Le nombre du haut dit de prendre {n} groupes : compte-les tous.",
    "Questo è un solo gruppo. Il numero in alto dice di prendere {n} gruppi: contali tutti.",
  ],
  "FbOtherGroups": [
    "That counts the groups you did not take. Count only {n, plural, =1{the group} other{the {n} groups}} the top number asks for.",
    "Das zählt die Gruppen, die du nicht genommen hast. Zähle nur {n, plural, =1{die Gruppe} other{die {n} Gruppen}}, die die obere Zahl verlangt.",
    "Cela compte les groupes que tu n'as pas pris. Compte seulement {n, plural, =1{le groupe} other{les {n} groupes}} que demande le nombre du haut.",
    "Così conti i gruppi che non hai preso. Conta solo i gruppi che chiede il numero in alto: {n, plural, =1{uno} other{{n}}}.",
  ],
  "FbWhole": [
    "That is the whole collection. The fraction is only part of it.",
    "Das ist die ganze Sammlung. Der Bruchteil ist nur ein Teil davon.",
    "C'est toute la collection. La fraction n'en est qu'une partie.",
    "Questa è tutta la raccolta. La frazione ne è solo una parte.",
  ],
  "FbFindGeneric": [
    "Make {groups} equal groups, then count the counters in {n, plural, =1{one of them} other{{n} of them}}.",
    "Bilde {groups} gleich grosse Gruppen und zähle dann die Plättchen in {n, plural, =1{einer davon} other{{n} davon}}.",
    "Forme {groups} groupes égaux, puis compte les jetons dans {n, plural, =1{un de ces groupes} other{{n} de ces groupes}}.",
    "Forma {groups} gruppi uguali, poi conta i gettoni in {n, plural, =1{uno di essi} other{{n} di essi}}.",
  ],
  "FbObjectCount": [
    "That is the number of chosen counters. The top number counts groups, not counters.",
    "Das ist die Anzahl der gewählten Plättchen. Die obere Zahl zählt Gruppen, nicht Plättchen.",
    "C'est le nombre de jetons choisis. Le nombre du haut compte des groupes, pas des jetons.",
    "Questo è il numero di gettoni scelti. Il numero in alto conta i gruppi, non i gettoni.",
  ],
  "FbGroupSize": [
    "That is how many counters are in one group. The top number counts the chosen groups.",
    "So viele Plättchen sind in einer Gruppe. Die obere Zahl zählt die gewählten Gruppen.",
    "C'est le nombre de jetons dans un groupe. Le nombre du haut compte les groupes choisis.",
    "Questo è quanti gettoni ci sono in un gruppo. Il numero in alto conta i gruppi scelti.",
  ],
  "FbNotChosen": [
    "That counts the groups that are not chosen.",
    "Das zählt die Gruppen, die nicht gewählt sind.",
    "Cela compte les groupes qui ne sont pas choisis.",
    "Così conti i gruppi che non sono scelti.",
  ],
  "FbWhatWhole": [
    "That would be all {groups} groups: the whole collection.",
    "Das wären alle {groups} Gruppen: die ganze Sammlung.",
    "Ce serait les {groups} groupes : toute la collection.",
    "Sarebbero tutti i gruppi ({groups} su {groups}): l'intera raccolta.",
  ],
  "FbWhatGeneric": [
    "Share the counters into {groups} equal groups, then count the groups that are chosen.",
    "Teile die Plättchen in {groups} gleich grosse Gruppen und zähle dann die gewählten Gruppen.",
    "Partage les jetons en {groups} groupes égaux, puis compte les groupes choisis.",
    "Dividi i gettoni in {groups} gruppi uguali, poi conta i gruppi scelti.",
  ],
  "FbBiggerDenominator": [
    "More equal groups means each group is smaller, so {fractionB} of {total} is less than {fractionA} of {total}.",
    "Mehr gleich grosse Gruppen heisst: Jede Gruppe ist kleiner. Darum ist {fractionB} von {total} weniger als {fractionA} von {total}.",
    "Plus il y a de groupes égaux, plus chaque groupe est petit. Donc {fractionB} de {total}, c'est moins que {fractionA} de {total}.",
    "Più gruppi uguali significa che ogni gruppo è più piccolo. Quindi {fractionB} di {total} è meno di {fractionA} di {total}.",
  ],
  "FbSame": [
    "Different numbers of equal groups give different group sizes, so these are not the same.",
    "Verschieden viele gleich grosse Gruppen ergeben verschieden grosse Gruppen. Darum ist es nicht gleich viel.",
    "Des nombres différents de groupes égaux donnent des groupes de tailles différentes : ce n'est donc pas pareil.",
    "Numeri diversi di gruppi uguali danno gruppi di grandezza diversa: quindi non sono uguali.",
  ],
  "FbUnequalTrays": [
    "Some trays have different numbers of counters, so the groups are not equal. The trays that differ are outlined. \"Deal one to each tray\" shares fairly.",
    "Einige Schalen haben verschieden viele Plättchen, also sind die Gruppen nicht gleich gross. Die Schalen, die abweichen, sind umrandet. «In jede Schale eins legen» teilt fair auf.",
    "Certains plateaux n'ont pas le même nombre de jetons : les groupes ne sont pas égaux. Les plateaux différents sont entourés. « Un jeton dans chaque plateau » partage équitablement.",
    "Alcuni vassoi hanno un numero diverso di gettoni: i gruppi non sono uguali. I vassoi diversi sono contornati. «Uno in ogni vassoio» divide in modo equo.",
  ],
  "FbUnequalAccepted": [
    "Look again: two trays have different counts. They are outlined. Equal groups must all be the same size.",
    "Schau noch einmal: Zwei Schalen haben eine andere Anzahl. Sie sind umrandet. Gleich grosse Gruppen haben alle gleich viele.",
    "Regarde encore : deux plateaux n'ont pas le même nombre. Ils sont entourés. Des groupes égaux ont tous la même taille.",
    "Guarda di nuovo: due vassoi hanno un numero diverso. Sono contornati. I gruppi uguali hanno tutti la stessa grandezza.",
  ],
  "FbEqualRejected": [
    "Every tray has {size} counters, so these groups are equal.",
    "Jede Schale hat {size} Plättchen, also sind diese Gruppen gleich gross.",
    "Chaque plateau a {size} jetons : ces groupes sont donc égaux.",
    "Ogni vassoio ha {size} gettoni: quindi questi gruppi sono uguali.",
  ],
  "Next": [
    "Next",
    "Weiter",
    "Suivant",
    "Avanti",
  ],
  "ExploreAgain": [
    "Explore again",
    "Nochmals erkunden",
    "Explorer à nouveau",
    "Esplora di nuovo",
  ],
  "Back": [
    "Back",
    "Zurück",
    "Retour",
    "Indietro",
  ],
  "StepperIncrease": [
    "Increase",
    "Erhöhen",
    "Augmenter",
    "Aumenta",
  ],
  "StepperDecrease": [
    "Decrease",
    "Verringern",
    "Diminuer",
    "Diminuisci",
  ],
  "Halves": [
    "{n, plural, =1{one half} other{{n} halves}}",
    "{n, plural, =1{ein Halb} other{{n} Halbe}}",
    "{n, plural, =1{un demi} other{{n} demis}}",
    "{n, plural, =1{un mezzo} other{{n} mezzi}}",
  ],
  "Thirds": [
    "{n, plural, =1{one third} other{{n} thirds}}",
    "{n, plural, =1{ein Drittel} other{{n} Drittel}}",
    "{n, plural, =1{un tiers} other{{n} tiers}}",
    "{n, plural, =1{un terzo} other{{n} terzi}}",
  ],
  "Quarters": [
    "{n, plural, =1{one quarter} other{{n} quarters}}",
    "{n, plural, =1{ein Viertel} other{{n} Viertel}}",
    "{n, plural, =1{un quart} other{{n} quarts}}",
    "{n, plural, =1{un quarto} other{{n} quarti}}",
  ],
  "Fifths": [
    "{n, plural, =1{one fifth} other{{n} fifths}}",
    "{n, plural, =1{ein Fünftel} other{{n} Fünftel}}",
    "{n, plural, =1{un cinquième} other{{n} cinquièmes}}",
    "{n, plural, =1{un quinto} other{{n} quinti}}",
  ],
  "Sixths": [
    "{n, plural, =1{one sixth} other{{n} sixths}}",
    "{n, plural, =1{ein Sechstel} other{{n} Sechstel}}",
    "{n, plural, =1{un sixième} other{{n} sixièmes}}",
    "{n, plural, =1{un sesto} other{{n} sesti}}",
  ],
  "Eighths": [
    "{n, plural, =1{one eighth} other{{n} eighths}}",
    "{n, plural, =1{ein Achtel} other{{n} Achtel}}",
    "{n, plural, =1{un huitième} other{{n} huitièmes}}",
    "{n, plural, =1{un ottavo} other{{n} ottavi}}",
  ],
  "Tenths": [
    "{n, plural, =1{one tenth} other{{n} tenths}}",
    "{n, plural, =1{ein Zehntel} other{{n} Zehntel}}",
    "{n, plural, =1{un dixième} other{{n} dixièmes}}",
    "{n, plural, =1{un decimo} other{{n} decimi}}",
  ],
};
