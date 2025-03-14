//
//  PhoneNumberInputView.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.01.29.
//

import UIKit

class PhoneNumberInputView: UIView {

    // MARK: - Font
    
    static private let numTextFieldFont = UIFont.notoSans(.regular, size: 24)
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
        setupTextFields()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Properties
    
    let backButton = UIButton().then {
        $0.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        $0.tintColor = .black
    }
    
    private let topStack = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.spacing = 0
    }
    
    private let topMainLabel = LoginLabel(title: "안녕하세요, ", type: .main)
    
    private let weggyImage = UIImageView().then {
        $0.image = UIImage(named: "weggy!")
    }
    
    private let bottomMainLabel = LoginLabel(title: "전화번호가 어떻게 되시나요?", type: .main)
    
    private let numberLabel = UILabel().then {
        $0.text = "전화번호"
        $0.font = UIFont.LoginFont.label
        $0.textColor = UIColor.LoginColor.labelColor
    }
    
    let firstTextField = UITextField().then {
        $0.keyboardType = .numberPad
        $0.textAlignment = .center
        $0.font = numTextFieldFont
        $0.textColor = .black
    }
    
    let secondTextField = UITextField().then {
        $0.keyboardType = .numberPad
        $0.textAlignment = .center
        $0.font = numTextFieldFont
        $0.textColor = .black
    }
    
    let thirdTextField = UITextField().then {
        $0.keyboardType = .numberPad
        $0.textAlignment = .center
        $0.font = numTextFieldFont
        $0.textColor = .black
    }
    
    let textFieldStack = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.spacing = 58
    }
    
    let underLine = UIView().then {
        $0.backgroundColor = UIColor.LoginColor.labelColor
    }
    
    let sendVerificationButton = LoginButton(
        style: .textOnly,
        title: "인증 번호 보내기",
        backgroundColor: .primary
    )
    
    // MARK: - Setup
    
    private func setupViews() {
        [topMainLabel, weggyImage].forEach { topStack.addArrangedSubview($0) }
        
        [
            firstTextField,
            secondTextField,
            thirdTextField
        ].forEach {
            textFieldStack.addArrangedSubview($0)
            $0.borderStyle = .none
        }
        
        [
            backButton,
            topStack,
            bottomMainLabel,
            numberLabel,
            textFieldStack,
            underLine,
            sendVerificationButton
        ].forEach { addSubview($0) }
    }
    
    private func setupConstraints() {
        backButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(70)
            make.leading.equalToSuperview().offset(17)
            make.width.equalTo(8)
        }
        
        topStack.snp.makeConstraints { make in
            make.top.equalTo(backButton.snp.bottom).offset(22)
            make.leading.equalTo(backButton)
        }
        
        bottomMainLabel.snp.makeConstraints { make in
            make.top.equalTo(topStack.snp.bottom)
            make.leading.equalTo(backButton)
        }
        
        numberLabel.snp.makeConstraints { make in
            make.top.equalTo(bottomMainLabel.snp.bottom).offset(50)
            make.leading.equalTo(backButton)
        }
        
        textFieldStack.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(numberLabel.snp.bottom).offset(18)
            make.height.equalTo(30)
            make.leading.equalTo(backButton.snp.leading).offset(46)
        }
        
        setupTextFieldConstraints()
        
        underLine.snp.makeConstraints { make in
            make.top.equalTo(textFieldStack.snp.bottom).offset(6)
            make.centerX.equalToSuperview()
            make.leading.equalTo(backButton)
            make.height.equalTo(1)
        }
        
        sendVerificationButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-40)
        }
    }
    
    private func setupTextFieldConstraints() {
        firstTextField.snp.makeConstraints { make in
            make.width.equalTo(40)
        }
        
        secondTextField.snp.makeConstraints { make in
            make.width.equalTo(60)
        }
        
        thirdTextField.snp.makeConstraints { make in
            make.width.equalTo(60)
        }
    }
    
    private func setupTextFields() {
        [firstTextField, secondTextField, thirdTextField].forEach {
            $0.delegate = self
            $0.keyboardType = .numberPad
            $0.textAlignment = .center
        }
    }
}

extension PhoneNumberInputView: UITextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        // 현재 텍스트와 새로운 문자열을 합친 결과
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        // 백스페이스는 허용
        if string.isEmpty {
            return true
        }
        
        // 숫자만 입력 가능하도록
        let numberOnly = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        if !characterSet.isSubset(of: numberOnly) {
            return false
        }
        
        // 각 TextField의 최대 길이 체크
        if textField == firstTextField {
            return updatedText.count <= 3
        } else {
            return updatedText.count <= 4
        }
    }
}
