//
//  PaymentViewModel.swift
//  FluxAIViewModel
//
//  Created by Er Baghdasaryan on 27.02.25.
//

import Foundation
import FluxAIModele

public protocol IPaymentViewModel {

}

public class PaymentViewModel: IPaymentViewModel {

    private let paymentService: IPaymentService

    public init(paymentService: IPaymentService) {
        self.paymentService = paymentService
    }
}
