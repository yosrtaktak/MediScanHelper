import 'dart:async';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mediscanhelper/core/services/image_processor.dart';

/// Classe de données pour les médicaments détectés
class MedicationData {
  final String name;
  final String dosage;
  final int frequency;
  final int? durationDays;

  MedicationData({
    required this.name,
    required this.dosage,
    required this.frequency,
    this.durationDays,
  });
}

/// Résultat du scan
class ScanResult {
  final bool isSuccess;
  final String? imagePath;
  final String? errorMessage;

  ScanResult({
    required this.isSuccess,
    this.imagePath,
    this.errorMessage,
  });
}

/// Service de scan d'ordonnances utilisant ML Kit
/// Optimisé pour la reconnaissance d'écriture manuscrite
class ScannerService {
  final ImagePicker _picker = ImagePicker();

  // Utiliser le recognizer Latin pour une meilleure précision sur les lettres latines
  static final TextRecognizer _latinTextRecognizer = TextRecognizer(
    script: TextRecognitionScript.latin,
  );
  
  // Recognizer par défaut comme fallback
  static final TextRecognizer _defaultTextRecognizer = TextRecognizer();
  
  static final ImageProcessor _imageProcessor = ImageProcessor();

  // Timeout pour éviter les blocages
  static const Duration _processingTimeout = Duration(seconds: 20);

  // Base de données de médicaments courants en Tunisie (pour améliorer la reconnaissance)
  static const List<String> _knownMedications = [
    'DOLIPRANE', 'PARACETAMOL', 'EFFERALGAN', 'DAFALGAN',
    'AMOXICILLINE', 'AUGMENTIN', 'CLAMOXYL',
    'IBUPROFENE', 'ADVIL', 'NUROFEN',
    'VOLTARENE', 'DICLOFENAC',
    'OMEPRAZOLE', 'INEXIUM', 'MOPRAL',
    'METFORMINE', 'GLUCOPHAGE',
    'AMLODIPINE', 'AMLOR',
    'ATORVASTATINE', 'TAHOR', 'LIPITOR',
    'LEVOTHYROX', 'EUTHYROX',
    'LORAZEPAM', 'TEMESTA',
    'ALPRAZOLAM', 'XANAX',
    'ZOPICLONE', 'IMOVANE',
    'TRAMADOL', 'TRAMAL', 'TOPALGIC',
    'CODEINE', 'CODOLIPRANE',
    'CELEBREX', 'CELECOXIB',
    'ASPIRINE', 'KARDEGIC',
    'CLOPIDOGREL', 'PLAVIX',
    'WARFARINE', 'COUMADINE',
    'METOPROLOL', 'LOPRESSOR', 'SELOKEN',
    'BISOPROLOL', 'CARDENSIEL',
    'RAMIPRIL', 'TRIATEC',
    'LISINOPRIL', 'ZESTRIL',
    'LOSARTAN', 'COZAAR',
    'FUROSEMIDE', 'LASILIX',
    'HYDROCHLOROTHIAZIDE',
    'SPIRIVA', 'TIOTROPIUM',
    'VENTOLINE', 'SALBUTAMOL',
    'SERETIDE', 'SYMBICORT',
    'SINGULAIR', 'MONTELUKAST',
    'AERIUS', 'DESLORATADINE',
    'ZYRTEC', 'CETIRIZINE',
    'GAVISCON', 'MAALOX',
    'SMECTA', 'IMODIUM',
    'SPASFON', 'PHLOROGLUCINOL',
    'DAFLON', 'VEINOTONIQUE',
    'EXOMUC', 'ACETYLCYSTEINE',
    'CLAM', 'AUG', 'AMOX', // Short forms often used by doctors
    'PHYSIOL', 'SERUM',
    'BETADINE', 'BISO',
    'PANTOMED', 'INEX',
    'KAR', 'ASP',
  ];

  // Mots à ignorer (souvent confondus avec des noms de médicaments)
  static const List<String> _blocklist = [
    'MATIN', 'MIDI', 'SOIR',
    'CP', 'ORAL', 'INJ', 'IV', 'IM',
    'JOUR', 'JOURS', 'SEMAINE', 'MOIS',
    'DURANT', 'PENDANT', 'POUR',
    'AVANT', 'APRES', 'REPAS',
    'CONSULTATION', 'ORDONNANCE', 'DOCTEUR',
    'TELEPHONE', 'TEL', 'FAX',
    'CLINIQUE', 'HOPITAL', 'CABINET',
    'MG', 'ML', 'G', 'UI',
    'UN', 'DEUX', 'TROIS',
    'FOIS', 'PAR',
    'RESULTAT', 'LABORATOIRE', 'ANALYSE',
    'DATE', 'NOM', 'PRENOM', 'AGE',
  ];

  /// Dispose des ressources
  void dispose() {
    _imageProcessor.cleanupTempFiles();
  }

  /// Méthode statique pour fermer les recognizers partagés
  static void disposeShared() {
    _latinTextRecognizer.close();
    _defaultTextRecognizer.close();
  }

  /// Scanner depuis la caméra
  Future<ScanResult> scanFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85, // Qualité plus élevée pour l'écriture manuscrite
        maxWidth: 2000,
        maxHeight: 2000,
      );

      if (image == null) {
        return ScanResult(
          isSuccess: false,
          errorMessage: 'Aucune image capturée',
        );
      }

      return ScanResult(
        isSuccess: true,
        imagePath: image.path,
      );
    } catch (e) {
      return ScanResult(
        isSuccess: false,
        errorMessage: 'Erreur lors de la capture: $e',
      );
    }
  }

  /// Scanner depuis la galerie
  Future<ScanResult> scanFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 2000,
        maxHeight: 2000,
      );

      if (image == null) {
        return ScanResult(
          isSuccess: false,
          errorMessage: 'Aucune image sélectionnée',
        );
      }

      return ScanResult(
        isSuccess: true,
        imagePath: image.path,
      );
    } catch (e) {
      return ScanResult(
        isSuccess: false,
        errorMessage: 'Erreur lors de la sélection: $e',
      );
    }
  }

  /// Extrait le texte d'une image avec reconnaissance multi-pass
  /// Pass 1: Image originale avec recognizer Latin
  /// Pass 2: Image prétraitée pour écriture manuscrite
  /// Combine les résultats pour une meilleure précision
  Future<String> extractText(String imagePath) async {
    try {
      final results = <String>[];

      // Pass 1: Image originale avec recognizer Latin
      try {
        final compressedImage = await _imageProcessor.compressImage(imagePath);
        final inputImage = InputImage.fromFilePath(compressedImage.path);
        
        final recognizedText = await _latinTextRecognizer
            .processImage(inputImage)
            .timeout(_processingTimeout);
        
        if (recognizedText.text.isNotEmpty) {
          results.add(recognizedText.text);
          print('Pass 1 (Latin): ${recognizedText.text.length} caractères');
        }
      } catch (e) {
        print('Pass 1 erreur: $e');
      }

      // Pass 2: Image prétraitée pour écriture manuscrite
      try {
        final preprocessedImage = await _imageProcessor.preprocessForHandwriting(imagePath);
        final inputImage = InputImage.fromFilePath(preprocessedImage.path);
        
        final recognizedText = await _latinTextRecognizer
            .processImage(inputImage)
            .timeout(_processingTimeout);
        
        if (recognizedText.text.isNotEmpty) {
          results.add(recognizedText.text);
          print('Pass 2 (Handwriting preprocessed): ${recognizedText.text.length} caractères');
        }
      } catch (e) {
        print('Pass 2 erreur: $e');
      }

      // Pass 3: Fallback avec recognizer par défaut si peu de résultats
      if (results.isEmpty || results.every((r) => r.length < 20)) {
        try {
          final compressedImage = await _imageProcessor.compressImage(imagePath);
          final inputImage = InputImage.fromFilePath(compressedImage.path);
          
          final recognizedText = await _defaultTextRecognizer
              .processImage(inputImage)
              .timeout(_processingTimeout);
          
          if (recognizedText.text.isNotEmpty) {
            results.add(recognizedText.text);
            print('Pass 3 (Default fallback): ${recognizedText.text.length} caractères');
          }
        } catch (e) {
          print('Pass 3 erreur: $e');
        }
      }

      if (results.isEmpty) {
        throw Exception('Aucun texte détecté dans l\'image');
      }

      // Combiner les résultats en gardant le plus complet
      final combinedText = _combineRecognitionResults(results);
      print('Texte combiné final: ${combinedText.length} caractères');
      
      return combinedText;
    } on TimeoutException {
      throw Exception('Le traitement a pris trop de temps. Essayez avec une image plus petite.');
    } catch (e) {
      throw Exception('Erreur lors de l\'extraction du texte: $e');
    }
  }

  /// Combine les résultats de plusieurs passes de reconnaissance
  String _combineRecognitionResults(List<String> results) {
    if (results.isEmpty) return '';
    if (results.length == 1) return results.first;

    // Prendre le résultat le plus long comme base
    results.sort((a, b) => b.length.compareTo(a.length));
    String bestResult = results.first;

    // Chercher des mots reconnus dans d'autres passes mais pas dans la meilleure
    final bestWords = bestResult.toLowerCase().split(RegExp(r'\s+'));
    
    for (int i = 1; i < results.length; i++) {
      final otherWords = results[i].split(RegExp(r'\s+'));
      for (final word in otherWords) {
        // Si un mot ressemble à un médicament connu et n'est pas dans le meilleur résultat
        final matchedMed = _findMatchingMedication(word);
        if (matchedMed != null && !bestWords.contains(matchedMed.toLowerCase())) {
          // Ajouter une note sur ce médicament potentiel
          print('Médicament potentiel trouvé dans autre pass: $matchedMed');
        }
      }
    }

    return bestResult;
  }

  /// Trouve un médicament correspondant dans la base de données
  String? _findMatchingMedication(String word) {
    if (word.length < 4) return null;
    
    final upperWord = word.toUpperCase();
    
    // Correspondance exacte
    if (_knownMedications.contains(upperWord)) {
      return upperWord;
    }

    // Correspondance fuzzy (distance de Levenshtein simplifiée)
    for (final med in _knownMedications) {
      if (_isSimilar(upperWord, med)) {
        return med;
      }
    }

    return null;
  }

  /// Vérifie si deux chaînes sont similaires (tolérance aux erreurs OCR)
  bool _isSimilar(String a, String b) {
    if (a.length < 4 || b.length < 4) return false;
    
    // Si l'un contient l'autre
    if (a.contains(b) || b.contains(a)) return true;
    
    // Comparaison avec tolérance
    if ((a.length - b.length).abs() > 2) return false;
    
    int matches = 0;
    final shorter = a.length <= b.length ? a : b;
    final longer = a.length > b.length ? a : b;
    
    for (int i = 0; i < shorter.length; i++) {
      if (i < longer.length && shorter[i] == longer[i]) {
        matches++;
      }
    }
    
    // Au moins 70% des caractères doivent correspondre
    return matches >= shorter.length * 0.7;
  }

  /// Corrige les erreurs OCR courantes dans l'écriture manuscrite
  String _correctOcrErrors(String text) {
    String corrected = text;
    
    // Corrections courantes pour les erreurs OCR
    final corrections = {
      r'\b0(\d)': r'O$1',  // 0 au début d'un mot -> O
      r'(\d)0\b': r'${1}O', // 0 à la fin -> O potentiellement
      r'\bl\b': 'I',        // l seul -> I
      r'\bll\b': 'II',      // ll -> II
      r'rn': 'm',           // rn -> m
      r'vv': 'w',           // vv -> w
      r'\bc1': 'cl',        // c1 -> cl
      r'1ng': 'ing',        // 1ng -> ing
    };

    corrections.forEach((pattern, replacement) {
      corrected = corrected.replaceAll(RegExp(pattern), replacement);
    });

    return corrected;
  }

  /// Parse les médicaments depuis le texte extrait
  /// Amélioré avec filtrage strict et meilleure gestion du contexte
  List<MedicationData> parseMedications(String text) {
    final List<MedicationData> medications = [];
    
    // Corriger les erreurs OCR courantes
    final correctedText = _correctOcrErrors(text);
    final lines = correctedText.split('\n');

    // Patterns de dosage
    final dosagePatterns = [
      RegExp(r'(\d+)\s*(?:mg|g|ml|µg|mcg|UI|%)', caseSensitive: false),
      RegExp(r'(\d+(?:[,\.]\d+)?)\s*(?:mg|g|ml|µg|mcg|UI|%)', caseSensitive: false),
      RegExp(r'(\d+)\s*/\s*(\d+)\s*(?:mg|g|ml)', caseSensitive: false),
    ];

    // Patterns de fréquence
    final frequencyPatterns = [
      RegExp(r'(\d+)\s*(?:fois|x|fois\s*/\s*(?:jour|j)|par\s*jour|/\s*j(?:our)?)', caseSensitive: false),
      RegExp(r'(\d+)\s*(?:cp|comp(?:rimé)?s?|gél(?:ule)?s?|sachet?s?|amp(?:oule)?s?)\s*(?:/\s*j(?:our)?)?', caseSensitive: false),
      RegExp(r'(?:matin|midi|soir|nuit)', caseSensitive: false),
      RegExp(r'(\d+)\s*-\s*(\d+)\s*-\s*(\d+)', caseSensitive: false),
    ];

    final durationPattern = RegExp(
      r'(?:pendant|durant|sur|x|pour)\s*(\d+)\s*(?:jours?|j|semaines?|sem|mois)',
      caseSensitive: false,
    );

    String? currentMedName;
    String? currentDosage;
    int? currentFrequency;
    int? currentDuration;

    // Buffer pour accumuler les fréquences (ex: "matin et soir" -> 2)
    int frequencyAccumulator = 0;

    for (var i = 0; i < lines.length; i++) {
      final line = lines[i].trim();
      if (line.isEmpty) continue;
      if (line.length < 3) continue;

      // Normalisation pour vérification
      final upperLine = line.toUpperCase();
      
      // Vérifier si la ligne est un mot clé à ignorer (blocklist)
      // Si la ligne commence par un mot de la blocklist, ce n'est probablement pas un médicament
      bool isBlocked = _blocklist.any((block) => upperLine.startsWith(block));
      
      // Exception: Si on a déjà un médicament, et que c'est "MATIN" etc, ce n'est pas blocked mais c'est une fréquence
      if (currentMedName != null && isBlocked) {
        // C'est probablement une instruction pour le médicament en cours, on laisse passer pour l'analyse de fréquence
      } else if (isBlocked) {
        continue;
      }

      // Detection MÉDICAMENT
      String? detectedMedName;
      
      // 1. Chercher dans les médicaments connus (priorité absolue)
      for (final med in _knownMedications) {
        // En début de ligne ou mot entier
        if (upperLine.startsWith(med) || upperLine.contains(' $med ') || upperLine.endsWith(' $med')) {
          detectedMedName = med;
          // Si le nom détecté est très court (<4 chars), on vérifie le contexte pour éviter les faux positifs
          if (med.length < 4 && !upperLine.startsWith(med)) {
             detectedMedName = null;
          } else {
             break;
          }
        }
      }

      // 2. Si pas connu, heuristique de détection de nom
      if (detectedMedName == null && currentMedName == null) {
        // Un nom de médicament est souvent en majuscules, au début de la ligne, et ne contient pas de chiffres (sauf dosage)
        // On évite les lignes qui ressemblent à des dosages ou fréquences
        bool looksLikeDosage = dosagePatterns.any((p) => p.hasMatch(line));
        bool looksLikeFreq = frequencyPatterns.any((p) => p.hasMatch(line));
        
        if (!looksLikeDosage && !looksLikeFreq && !isBlocked) {
           // Regex pour nom potentiel: Commence par lettre, min 4 chars, pas trop de symboles
           final nameMatch = RegExp(r'^([A-Z][a-zA-Z\-\s]{3,})').firstMatch(line);
           if (nameMatch != null) {
             final candidate = nameMatch.group(1)?.trim();
             // Filtrer encore via blocklist et longueur
             if (candidate != null && 
                 candidate.length >= 4 && 
                 !_blocklist.contains(candidate.toUpperCase())) {
                detectedMedName = candidate;
             }
           }
        }
      }

      // NOUVEAU MÉDICAMENT DÉTECTÉ
      if (detectedMedName != null) {
        // Si on a un médicament en cours, on le sauvegarde
        if (currentMedName != null) {
          medications.add(MedicationData(
            name: currentMedName,
            dosage: currentDosage ?? 'Non spécifié',
            frequency: currentFrequency ?? (frequencyAccumulator > 0 ? frequencyAccumulator : 1),
            durationDays: currentDuration,
          ));
        }

        // Réinitialiser le contexte
        currentMedName = detectedMedName; // On garde tel quel ou on formate ?
        currentDosage = null;
        currentFrequency = null;
        currentDuration = null;
        frequencyAccumulator = 0;
        
        // Essayer d'extraire le dosage sur la même ligne
        for (final pattern in dosagePatterns) {
          final match = pattern.firstMatch(line);
          if (match != null) {
            currentDosage = match.group(0);
            break;
          }
        }
        
        continue; // Passer à la ligne suivante (ou on analyse le reste de la ligne ?)
      }

      // ANALYSE DES DÉTAILS (DOSAGE, FRÉQUENCE) POUR LE MÉDICAMENT EN COURS
      if (currentMedName != null) {
        // Dosage (si pas encore trouvé)
        if (currentDosage == null) {
          for (final pattern in dosagePatterns) {
            final match = pattern.firstMatch(line);
            if (match != null) {
              currentDosage = match.group(0);
              break;
            }
          }
        }

        // Fréquence
        if (currentFrequency == null) {
          bool freqFound = false;
          for (final pattern in frequencyPatterns) {
            final matches = pattern.allMatches(line);
            for (final match in matches) {
              freqFound = true;
               // Format 1-0-1
              if (pattern.pattern.contains(r'(\d+)\s*-\s*(\d+)\s*-\s*(\d+)')) {
                  currentFrequency = 
                      (int.tryParse(match.group(1) ?? '0') ?? 0) +
                      (int.tryParse(match.group(2) ?? '0') ?? 0) +
                      (int.tryParse(match.group(3) ?? '0') ?? 0);
              } 
              // Matin/Midi/Soir -> Accumulateur
              else if (pattern.pattern.contains('matin|midi|soir')) {
                 // Compter chaque occurrence comme une prise
                 frequencyAccumulator++;
              }
              // X fois par jour
              else if (match.groupCount >= 1) {
                 final val = int.tryParse(match.group(1) ?? '');
                 if (val != null) {
                   // Si c'est "2 comprimés", ca peut être le dosage ou la fréquence (2 fois ou 2 caps en 1 fois)
                   // On assume fréquence si suivi de "par jour" ou "/j"
                   if (line.contains('/j') || line.contains('par jour') || line.contains('fois')) {
                     currentFrequency = val;
                   } else {
                     // Ambigu, souvent c'est "2 cp le soir" -> freq = 1 (prise le soir), dosage = 2cp?
                     // Simplification: on prend comme fréquence par défaut
                     currentFrequency = val;
                   }
                 }
              }
            }
          }
          // Si on a accumulé (ex: matin + soir), on met à jour si pas de fréquence explicite "X fois" trouvée
          if (currentFrequency == null && frequencyAccumulator > 0) {
             // On ne définit pas encore currentFrequency car on peut trouver d'autres termes sur les lignes suivantes
             // On utilisera l'accumulateur à la fin
          }
        }

        // Durée
        if (currentDuration == null) {
          final match = durationPattern.firstMatch(line);
          if (match != null) {
            final val = int.tryParse(match.group(1) ?? '0');
            if (val != null && val > 0) {
              if (upperLine.contains('SEM')) currentDuration = val * 7;
              else if (upperLine.contains('MOIS')) currentDuration = val * 30;
              else currentDuration = val;
            }
          }
        }
      }
    }

    // Ajouter le dernier médicament
    if (currentMedName != null) {
      medications.add(MedicationData(
        name: currentMedName,
        dosage: currentDosage ?? 'Non spécifié',
        frequency: currentFrequency ?? (frequencyAccumulator > 0 ? frequencyAccumulator : 1),
        durationDays: currentDuration,
      ));
    }

    return medications;
  }
}
