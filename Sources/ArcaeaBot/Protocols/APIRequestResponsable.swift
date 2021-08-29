protocol APIRequestResponsable: Codable {
    associatedtype C: Codable

    var status: Int { get set }
    var content: C { get set }
}
