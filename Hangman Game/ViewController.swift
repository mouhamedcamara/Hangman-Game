//
//  ViewController.swift
//  Hangman Game
//
//  Created by Mouhamed Camara on 10/2/20.
//

import UIKit

class ViewController: UIViewController
{
    //MARK: Outlets
    
    @IBOutlet weak var hintLabel: UILabel!
    
    @IBOutlet weak var wordToGuessLabel: UILabel!
    
    @IBOutlet weak var remainingGuessesLabel: UILabel!
    
    @IBOutlet weak var inputTextField: UITextField!
    
    @IBOutlet weak var letterBankLabel: UILabel!
    
    
    //MARK: Actions
    
    @IBAction func chooseNewWordAction(_ sender: UIButton)
    {
        reset()
        
        let index = chooseRandomNumber()
        
        wordToGuess = List_Of_Words[index]
        
        for _ in 1...wordToGuess.count
        {
            wordAsUnderscores.append("_")
        }
        
        
        wordToGuessLabel.text = wordAsUnderscores
        
        theHint = List_Of_Hints[index]
        let hint = List_Of_Hints[index]
        hintLabel.text = "Hint: \(hint) \(wordToGuess.count) letters"
    }
    
    //MARK: Properties
    
    let List_Of_Words: [String] = [
        "hello",
        "goodbye",
        "mamoth",
        "hangman",
        "coffee"
    ]
    
    let List_Of_Hints: [String] = [
        "greeting",
        "farewell",
        "extinct mastadon",
        "letter guessing game",
        "a good way to wake up"
    ]
    
    var wordToGuess: String!
    
    var theHint: String!
    
    var guessesRemaining: Int!
    
    var wordAsUnderscores = String()
    
    let max_number_of_guesses = 5
    
    var oldRandomNumber = 0

    override func viewDidLoad()
    {
        super.viewDidLoad()
        inputTextField.delegate = self
        inputTextField.becomeFirstResponder()
        inputTextField.isEnabled = false
    }
    
    //MARK: Functions
    
    func chooseRandomNumber() -> Int
    {
        var randNumb = Int(arc4random_uniform(UInt32(List_Of_Words.count)))
        
        if randNumb == oldRandomNumber
        {
            randNumb = chooseRandomNumber()
        }
        else
        {
            oldRandomNumber = randNumb
        }
        return randNumb
    }
    
    func reset()
    {
        guessesRemaining = max_number_of_guesses
        remainingGuessesLabel.text = "\(guessesRemaining!) guesses left"
        wordAsUnderscores = ""
        inputTextField.text?.removeAll()
        letterBankLabel.text?.removeAll()
        inputTextField.isEnabled = true
    }
    
    func processCorrectGuess(letterGuessed: String)
    {
        let characterGuessed = Character(letterGuessed)
        for index in wordToGuess.indices
        {
            if wordToGuess[index] == characterGuessed
            {
                let endIndex = wordToGuess.index(after: index)
                let charRange = index..<endIndex
                wordAsUnderscores = wordAsUnderscores.replacingCharacters(in: charRange, with: letterGuessed)
                
                wordToGuessLabel.text = wordAsUnderscores
            }
        }
        
        if !wordAsUnderscores.contains("_")
        {
            remainingGuessesLabel.text = "You win :)"
            inputTextField.isEnabled = false
        }
    }
    
    func processIncorrectGuess()
    {
        guessesRemaining -= 1
        
        if guessesRemaining == 0
        {
            remainingGuessesLabel.text = "You lose :("
            inputTextField.isEnabled = false
        }
        else
        {
            remainingGuessesLabel.text = "\(guessesRemaining!) guesses left"
        }
    }
}


extension ViewController: UITextFieldDelegate
{
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        guard let letterGuessed = textField.text else {return}
        inputTextField.text?.removeAll()
        let currentLetterBank = letterBankLabel.text ?? ""
        
        if currentLetterBank.contains(letterGuessed)
        {
            return
        }
        else
        {
            if wordToGuess.contains(letterGuessed)
            {
                processCorrectGuess(letterGuessed: letterGuessed)
            }
            else
            {
                processIncorrectGuess()
            }
            letterBankLabel.text?.append("\(letterGuessed), ")
        }
        
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        textField.text?.removeAll()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        let allowedCharacters = NSCharacterSet.letters
        let startingLength = textField.text?.count ?? 0
        let lengthToAdd = string.count
        let lenghtToReplace = range.length
        let newLenght = startingLength + lengthToAdd - lenghtToReplace
        
        if string.isEmpty
        {
            return true
        }
        else if newLenght == 1
        {
            if let _ = string.rangeOfCharacter(from: allowedCharacters, options: .caseInsensitive)
            {
                return true
            }
        }
        return false
    }
    
    
}
