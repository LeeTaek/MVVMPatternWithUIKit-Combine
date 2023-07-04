//
//  ViewController.swift
//  testCombine
//
//  Created by leetaek on 2023/07/03.
//

import Combine
import UIKit

import SnapKit

class ViewController: UIViewController {
  // MARK: - UI Properties
  let IDTextField: UITextField = {
    let view = UITextField()
    view.layer.borderWidth = 1
    view.layer.borderColor = UIColor.lightGray.cgColor
    view.layer.cornerRadius = 10
    view.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
    view.leftViewMode = .always
    view.placeholder = " 아이디 입력하세요."
    return view
  }()
  
  let passwordTextField: UITextField = {
    let view = UITextField()
    view.layer.borderWidth = 1
    view.layer.borderColor = UIColor.lightGray.cgColor
    view.layer.cornerRadius = 10
    view.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
    view.leftViewMode = .always
    view.placeholder = "비밀번호를 입력하세요."
    return view
  }()
  
  let passwordReenterTextField: UITextField = {
    let view = UITextField()
    view.layer.borderWidth = 1
    view.layer.borderColor = UIColor.lightGray.cgColor
    view.layer.cornerRadius = 10
    view.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
    view.leftViewMode = .always
    view.placeholder = "비밀번호 재입력하세요"
    return view
  }()
  
  let signInButton: UIButton = {
    let view = UIButton()
    view.layer.cornerRadius = 20
    view.clipsToBounds = true
    view.setTitle("가입", for: .normal)
    return view
  }()
  
  
  // MARK: - Properties
//  private let user = PassthroughSubject<String, Never>()
//  private let password = PassthroughSubject<String, Never>()
//  private let passwordReenter = PassthroughSubject<String, Never>()

  private var cancellables = Set<AnyCancellable>()
  private let viewModel = ViewModel()
  
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    view.backgroundColor = .white
    addViews()
    setupLayout()
    bind(to: viewModel)
  
    
  }
  
  
  // MARK: - Methods
  private func addViews() {
    view.addSubview(IDTextField)
    view.addSubview(passwordTextField)
    view.addSubview(passwordReenterTextField)
    view.addSubview(signInButton)
    
//    [IDTextField, passwordTextField, passwordReenterTextField].forEach {
//      $0.addTarget(self, action: #selector(self.textFieldDidChange(sender:)), for: .editingChanged)
//    }
  }
  
  private func setupLayout() {
    IDTextField.snp.makeConstraints {
      $0.width.equalTo(200)
      $0.height.equalTo(50)
      $0.centerX.equalToSuperview()
      $0.centerY.equalToSuperview().offset(-100)
    }
    
    passwordTextField.snp.makeConstraints {
      $0.width.equalTo(200)
      $0.height.equalTo(50)
      $0.centerX.equalToSuperview()
      $0.top.equalTo(IDTextField.snp.bottom).offset(50)
    }
    
    passwordReenterTextField.snp.makeConstraints {
      $0.width.equalTo(200)
      $0.height.equalTo(50)
      $0.centerX.equalToSuperview()
      $0.top.equalTo(passwordTextField.snp.bottom).offset(50)
    }
    
    signInButton.snp.makeConstraints {
      $0.width.equalTo(100)
      $0.height.equalTo(50)
      $0.centerX.equalToSuperview()
      $0.top.equalTo(passwordReenterTextField.snp.bottom).offset(50)
    }
  }
  
  private func bind(to viewModel: ViewModel) {
    let input = ViewModel.Input(
      userName: IDTextField.textPublisher(),
      password: passwordTextField.textPublisher(),
      passwordReenter: passwordReenterTextField.textPublisher()
    )
    
    let output = viewModel.transform(input: input)
    
    output
      .buttonIsValid
      .sink { [weak self] state in
        print(state)
        self?.signInButton.isEnabled = state
        self?.signInButton.backgroundColor = state ? .systemOrange : .systemGray
      }
      .store(in: &cancellables)
    
    
    IDTextField
      .textPublisher()
      .sink { text in
        print(text)
      }
      .store(in: &cancellables)
    
    signInButton
      .publisher(for: .touchUpInside)
      .sink {  _ in
        print("sign in button tapped")
      }
      .store(in: &cancellables)
    
  }
  
//  @objc private func textFieldDidChange(sender: UITextField) {
//    switch sender {
//    case IDTextField:
//      user.send(sender.text!)
//    case passwordTextField:
//      password.send(sender.text!)
//    case passwordReenterTextField:
//      passwordReenter.send(sender.text!)
//    default:
//      break
//    }
//  }
  
}

