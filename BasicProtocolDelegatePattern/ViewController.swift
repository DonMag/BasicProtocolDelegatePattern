//
//  ViewController.swift
//  BasicProtocolDelegatePattern
//
//  Created by Don Mag on 1/26/22.
//

import UIKit

protocol BasicDelegate {
	func optionTypeChanged(type: String)
	func optionSizeChanged(index: Int, size: String)
	func doneTapped()
}

class ViewController: UIViewController, BasicDelegate {

	@IBOutlet var typeResultLabel: UILabel!
	@IBOutlet var sizeResultLabel: UILabel!

	var optionType: String = ""
	var optionSize: String = ""
	var optionSizeIndex: Int = 0

	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let vc = segue.destination as? OptionsViewController {
			// set the controller's .delegate to self
			vc.delegate = self
		}
	}

	func optionTypeChanged(type: String) {
		self.optionType = type
		typeResultLabel.text = self.optionType
	}
	func optionSizeChanged(index: Int, size: String) {
		self.optionSizeIndex = index
		self.optionSize = size
		sizeResultLabel.text = "Index: \(self.optionSizeIndex) Value: \(self.optionSize)"
	}

	func doneTapped() {
		dismiss(animated: true, completion: {
			// here we might want to do something because
			//	the user is done with the Options selections
			print("After Dismissing:", self.optionType, self.optionSizeIndex, self.optionSize)
		})
	}
}

class OptionsViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
	
	var delegate: BasicDelegate?
	
	@IBOutlet var typePicker: UIPickerView!
	@IBOutlet var sizeSegControl: UISegmentedControl!

	let optionTypes: [String] = [
		"First Type",
		"Another Type",
		"The Best Type",
		"The Worst Type",
		"Last Type",
	]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		typePicker.dataSource = self
		typePicker.delegate = self
	}

	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return optionTypes.count
	}
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return optionTypes[row]
	}
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		print("Selected:", optionTypes[row])
		// tell the delegate
		delegate?.optionTypeChanged(type: optionTypes[row])
	}
	
	@IBAction func sizeSegChanged(_ sender: UISegmentedControl) {
		let idx = sender.selectedSegmentIndex
		guard let title = sender.titleForSegment(at: idx) else { return }
		print("Selected Size:", sender.selectedSegmentIndex, title)
		// tell the delegate
		delegate?.optionSizeChanged(index: idx, size: title)
	}
	
	@IBAction func doneTapped(_ sender: Any) {
		print("Done Tapped")
		// tell the delegate
		delegate?.doneTapped()
	}
	
}
