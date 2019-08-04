//
//  Model Constants.swift
//  FindingMemoryLeaks
//
//  Created by Erick Olibo on 03/08/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import Foundation


public struct ModelConstants  {
    
    public static let letterTXT = "Letter"
    public static let clusterTXT = "Cluster_"
    
    public static let extTXT = ".txt"
    
    public static let markovBiGramChains = "MarkovBiGramChains.txt"
    public static let markovBiGramStart = "MarkovBiGramStart.txt"
    public static let markovTriGramChains = "MarkovTriGramChains.txt"
    public static let markovTriGramStart = "MarkovTriGramStart.txt"
    
    public static let biGramFreqTable = "BiGramFrequencyTable.txt"
    public static let statements_20K = "20K_Sample_Statements.txt"
    public static let finalCorpusFile = "RankedModelCorpus.txt"
    public static let synonymsRanked = "organizedSynonymsRanks.txt"
    
    public static let wantedLeftBiGrams = "WantedLeftBiGrams.txt"
    public static let wantedLeftTriGrams = "WantedLeftTriGrams.txt"
    public static let wantedLeftFourGrams = "WantedLeftFourGrams.txt"
    public static let wantedRightFourGrams = "WantedRightFourGrams.txt"
        
    
    public static let maxInAppLength = 13 // the max length if a particular length not requested
    public static let maxLength = 16 // This number depends on the biggest number of WordsLength (16Letter.txt)
    public static let minLength = 6 // Absolute minimum word creation
    public static let minCharacter = 2 // for the overall model
    public static let minMaxWordLength = (minLength...maxLength)
    public static let minMaxInAppWordLength = (minLength...maxInAppLength)
    
    public static let minAlgo: Double = 1.0
    public static let maxAlgo: Double = 5.0
    public static let minMaxAlgo = (minAlgo...maxAlgo)
    
    public static let numberOfClusters = 194 // from the number of files imported
    public static let numbCentroids = 5 // 5 is the default
    public static let numberOfNeighbors = 5 // default now: 5 --> ADJUST THIS NUMBER later if issues
    
    public static let maxIterations = 100
    public static let maxResultsPerTypeOfAlgorithm = 10
    
    // Alphabet, variations and blends
    public static let alphabet : Set = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
    public static let vowelsChar: [Character] = ["a", "e", "i", "o", "u", "y"]
    public static let vowels: Set = ["a", "e", "i", "o", "u", "y"]
    public static let consonants: Set = ["b", "c", "d", "f", "g", "h", "j", "k", "l", "m", "n", "p", "q", "r", "s", "t", "v", "w", "x", "z"]
    public static let consonantBlendStart: Set = ["bl", "br", "ch", "cl", "cr", "dr", "fl", "fr", "gl", "gr", "pl", "pr", "sc", "sh", "sk", "sl", "sm", "sn", "sp", "st", "sw", "th", "tr", "tw", "wh", "wr"]
    public static let consonantBlendEnd: Set = ["ft", "ld", "lf", "lp", "lt", "mp", "nd", "ng", "nk", "nt", "pt", "sk", "sp", "st", "xt"]
    public static let vowelBlend: Set = ["ai", "au", "ay", "ea", "ee", "ei", "eu", "ey", "ie", "oi", "oo", "ou", "oy"]
    public static let cons = "C"
    public static let vows = "V"
    
    
    
}


// MARK: - Public Enum
public enum SimilarityType {
    case cosine, euclidean
}

/// the different possibilities when a word has been broken down in the case
/// of the flavorizer randomizer. it keeps a track on where each part originated from
public enum BoundSide: String {
    case left, center, right
}


/// Tells the type of Algorithm that was used to create a madeUpWord
public enum MadeUpAlgo: String, CaseIterable, CustomStringConvertible, Codable {
    case concat, markovChain, simpleSwap, startBlendSwap, endBlendSwap, vowelsBlendSwap, substitute, flavor
    
    public var description: String {
        let descrp = self.rawValue
        let result = descrp.prefix(1).capitalized + descrp.suffix(descrp.count - 1)
        return result
    }
}



// MARK: - Public methods
public func isVowel(_ letter: String) -> Bool {
    return ModelConstants.vowels.contains(letter)
}





// MARK: - Public Structs
/// List of English Stop words as per NLP libraries (Spacy and NLTK)
public struct StopWords {
    public static let cleaned: Set = ["a", "about", "above", "across", "after", "afterwards", "again", "against", "all", "almost", "alone", "along", "already", "also", "although", "always", "among", "amongst", "amount", "an", "and", "another", "any", "anyhow", "anyone", "anything", "anyway", "anywhere", "are", "around", "as", "at", "back", "be", "became", "because", "become", "becomes", "becoming", "been", "before", "beforehand", "behind", "being", "below", "beside", "besides", "between", "beyond", "both", "bottom", "but", "by", "call", "can", "cannot", "could", "did", "do", "does", "doing", "done", "down", "due", "during", "each", "eight", "either", "eleven", "else", "elsewhere", "empty", "enough", "even", "ever", "every", "everyone", "everything", "everywhere", "except", "few", "fifteen", "fifty", "first", "five", "for", "former", "formerly", "forty", "four", "from", "front", "full", "further", "get", "give", "go", "had", "has", "have", "having", "he", "hence", "her", "here", "hereafter", "hereby", "herein", "hereupon", "hers", "herself", "him", "himself", "his", "how", "however", "hundred", "i", "if", "in", "indeed", "into", "is", "it", "its", "itself", "just", "keep", "last", "latter", "latterly", "least", "less", "made", "make", "many", "may", "me", "meanwhile", "might", "mine", "more", "moreover", "most", "mostly", "move", "much", "must", "my", "myself", "name", "namely", "neither", "never", "nevertheless", "next", "nine", "no", "nobody", "none", "noone", "nor", "not", "nothing", "now", "nowhere", "of", "off", "often", "on", "once", "one", "only", "onto", "or", "other", "others", "otherwise", "our", "ours", "ourselves", "out", "over", "own", "part", "per", "perhaps", "please", "put", "quite", "rather", "really", "regarding", "same", "say", "see", "seem", "seemed", "seeming", "seems", "serious", "several", "she", "should", "show", "side", "since", "six", "sixty", "so", "some", "somehow", "someone", "something", "sometime", "sometimes", "somewhere", "still", "such", "take", "ten", "than", "that", "the", "their", "theirs", "them", "themselves", "then", "thence", "there", "thereafter", "thereby", "therefore", "therein", "thereupon", "these", "they", "third", "this", "those", "though", "three", "through", "throughout", "thus", "to", "together", "too", "top", "toward", "towards", "twelve", "twenty", "two", "under", "unless", "until", "up", "upon", "us", "used", "using", "various", "very", "via", "was", "we", "well", "were", "what", "whatever", "when", "whence", "whenever", "where", "whereafter", "whereas", "whereby", "wherein", "whereupon", "wherever", "whether", "which", "while", "whither", "who", "whoever", "whole", "whom", "whose", "why", "will", "with", "within", "without", "won", "would", "yet", "you", "your", "yours", "yourself", "yourselves"]
    
}



