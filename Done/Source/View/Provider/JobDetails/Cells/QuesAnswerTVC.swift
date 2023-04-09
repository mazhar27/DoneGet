//
//  QuesAnswerTVC.swift
//  Done
//
//  Created by Mazhar Hussain on 12/09/2022.
//

import UIKit

class QuesAnswerTVC: UITableViewCell {

    @IBOutlet weak var answerLbl: UILabel!
    @IBOutlet weak var quesLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configureCell(item: Question_answers){
     quesLbl.text = item.question_title
        answerLbl.text = item.answers_detail
    }
    
}
