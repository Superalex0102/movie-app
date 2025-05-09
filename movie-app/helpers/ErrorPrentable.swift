//
//  ErrorPrentable.swift
//  movie-app
//
//  Created by Alexander Dominik Somogyi on 2025. 05. 09..
//

protocol ErrorPrentable {
    func toAlerModel(_ error: Error) -> AlertModel
}

extension ErrorPrentable {
    func toAlerModel(_ error: Error) -> AlertModel {
        guard let error = error as? MovieError else {
            return AlertModel(
                title: "unexpected.error.title",
                message: "unexpected.error.message",
                dismissButtonTitle: "button.close.text"
            )
        }
        switch error {
        case .invalidApiKeyError(let message):
            return AlertModel(
                title: "API Error",
                message: message,
                dismissButtonTitle: "button.close.text"
            )
        case .clientError:
            return AlertModel(
                title: "Client Error",
                message: error.localizedDescription,
                dismissButtonTitle: "button.close.text"
            )
        default:
            return AlertModel(
                title: "unexpected.error.title",
                message: "unexpected.error.message",
                dismissButtonTitle: "button.close.text"
            )
        }
    }
}
