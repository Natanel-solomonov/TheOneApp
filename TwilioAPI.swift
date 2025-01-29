import Foundation

class TwilioAPI {
    private let accountSID = Secrets.accountSID
    private let authToken = Secrets.authToken
    private let serviceSID = Secrets.serviceSID

    private var baseURL: URL {
        return URL(string: "https://verify.twilio.com/v2/Services/\(serviceSID)")!
    }

    func sendVerification(to phoneNumber: String, completion: @escaping (Result<Void, Error>) -> Void) {
        // Ensure the phone number has the correct format
        let formattedNumber = phoneNumber.hasPrefix("+") ? phoneNumber : "+1\(phoneNumber.filter { $0.isNumber })"

        // Properly encode the `To` parameter manually
        let encodedTo = "To=\(formattedNumber.replacingOccurrences(of: "+", with: "%2B"))"
        let body = "\(encodedTo)&Channel=sms"

        // Set up the request
        let url = baseURL.appendingPathComponent("Verifications")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue(
            "Basic \(Data("\(accountSID):\(authToken)".utf8).base64EncodedString())",
            forHTTPHeaderField: "Authorization"
        )
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = body.data(using: .utf8)

        // Debugging output
        print("Formatted Phone Number: \(formattedNumber)")
        print("Encoded Request Body: \(body)")

        // Send the request
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 201 {
                    completion(.success(()))
                } else {
                    let errorMessage = String(data: data ?? Data(), encoding: .utf8) ?? "Unknown error"
                    print("Twilio Error Response: \(errorMessage)")
                    print("HTTP Status Code: \(httpResponse.statusCode)")
                    completion(.failure(NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
                }
            }
        }.resume()
    }

    func checkVerification(for phoneNumber: String, code: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        let url = baseURL.appendingPathComponent("VerificationCheck")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue(
            "Basic \(Data("\(accountSID):\(authToken)".utf8).base64EncodedString())",
            forHTTPHeaderField: "Authorization"
        )
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        // Properly encode the `To` parameter
        let formattedNumber = phoneNumber.hasPrefix("+") ? phoneNumber : "+1\(phoneNumber.filter { $0.isNumber })"
        let encodedTo = "To=\(formattedNumber.replacingOccurrences(of: "+", with: "%2B"))"
        let body = "\(encodedTo)&Code=\(code)"
        request.httpBody = body.data(using: .utf8)

        // Debugging output
        print("Encoded Request Body for Verification: \(body)")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200, let data = data {
                    // Parse the response to determine if verification was successful
                    if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let status = json["status"] as? String, status == "approved" {
                        completion(.success(true))
                    } else {
                        let responseString = String(data: data, encoding: .utf8) ?? "Unknown response"
                        print("Twilio Response: \(responseString)") // Debugging
                        completion(.success(false))
                    }
                } else {
                    let errorMessage = String(data: data ?? Data(), encoding: .utf8) ?? "Unknown error"
                    print("HTTP Status Code: \(httpResponse.statusCode)")
                    print("Error Response: \(errorMessage)")
                    completion(.failure(NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
                }
            }
        }.resume()
    }
}

