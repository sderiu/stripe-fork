//
//  SubscriptionRoutes.swift
//  Stripe
//
//  Created by Andrew Edwards on 6/9/17.
//
//

import Vapor
import Foundation

public protocol SubscriptionRoutes {
    func create(customer: String, applicationFeePercent: Decimal?, billing: String?, billingCycleAnchor: Date?, cancelAtPeriodEnd: Bool?, coupon: String?, daysUntilDue: Int?, items: [[String : Any]]?, metadata: [String: String]?, prorate: Bool?, taxPercent: Decimal?, trialEnd: Any?, trialFromPlan: Bool?, trialPeriodDays: Int?, off_session: Bool?) throws -> Future<StripeSubscription>
    func retrieve(id: String) throws -> Future<StripeSubscription>
    func update(subscription: String, applicationFeePercent: Decimal?, billing: String?, billingCycleAnchor: String?, cancelAtPeriodEnd: Bool?, coupon: String?, daysUntilDue: Int?, items: [[String: Any]]?, metadata: [String: String]?, prorate: Bool?, prorationDate: Date?, taxPercent: Decimal?, trialEnd: Any?, trialFromPlan: Bool?) throws -> Future<StripeSubscription>
    func cancel(subscription: String, invoiceNow: Bool?, prorate: Bool?) throws -> Future<StripeSubscription>
    @available(*, deprecated, message: "Use update(subscription:cancelAtPeriodEnd:) instead")
    func cancel(subscription: String, atPeriodEnd: Bool) throws -> Future<StripeSubscription>
    func listAll(filter: [String: Any]?) throws -> Future<StripeSubscriptionsList>
    func deleteDiscount(subscription: String) throws -> Future<StripeDeletedObject>
}

extension SubscriptionRoutes {
    public func create(customer: String,
                       applicationFeePercent: Decimal? = nil,
                       billing: String? = nil,
                       billingCycleAnchor: Date? = nil,
                       cancelAtPeriodEnd: Bool? = nil,
                       coupon: String? = nil,
                       daysUntilDue: Int? = nil,
                       items: [[String: Any]]? = nil,
                       metadata: [String: String]? = nil,
                       prorate: Bool? = nil,
                       taxPercent: Decimal? = nil,
                       trialEnd: Any? = nil,
                       trialFromPlan: Bool? = nil,
                       trialPeriodDays: Int? = nil,
                       off_session: Bool? = false) throws -> Future<StripeSubscription> {
        return try create(customer: customer,
                          applicationFeePercent: applicationFeePercent,
                          billing: billing,
                          billingCycleAnchor: billingCycleAnchor,
                          cancelAtPeriodEnd: cancelAtPeriodEnd,
                          coupon: coupon,
                          daysUntilDue: daysUntilDue,
                          items: items,
                          metadata: metadata,
                          prorate: prorate,
                          taxPercent: taxPercent,
                          trialEnd: trialEnd,
                          trialFromPlan: trialFromPlan,
                          trialPeriodDays: trialPeriodDays,
                          off_session: off_session)
    }
    
    public func retrieve(id: String) throws -> Future<StripeSubscription> {
        return try retrieve(id: id)
    }
    
    public func update(subscription: String,
                       applicationFeePercent: Decimal? = nil,
                       billing: String? = nil,
                       billingCycleAnchor: String? = nil,
                       cancelAtPeriodEnd: Bool? = nil,
                       coupon: String? = nil,
                       daysUntilDue: Int? = nil,
                       items: [[String: Any]]? = nil,
                       metadata: [String: String]? = nil,
                       prorate: Bool? = nil,
                       prorationDate: Date? = nil,
                       taxPercent: Decimal? = nil,
                       trialEnd: Any? = nil,
                       trialFromPlan: Bool? = nil) throws -> Future<StripeSubscription> {
        return try update(subscription: subscription,
                          applicationFeePercent: applicationFeePercent,
                          billing: billing,
                          billingCycleAnchor: billingCycleAnchor,
                          cancelAtPeriodEnd: cancelAtPeriodEnd,
                          coupon: coupon,
                          daysUntilDue: daysUntilDue,
                          items: items,
                          metadata: metadata,
                          prorate: prorate,
                          prorationDate: prorationDate,
                          taxPercent: taxPercent,
                          trialEnd: trialEnd,
                          trialFromPlan: trialFromPlan)
    }
    
    public func cancel(subscription: String, invoiceNow: Bool? = nil, prorate: Bool? = nil) throws -> Future<StripeSubscription> {
        return try cancel(subscription: subscription, invoiceNow: invoiceNow, prorate: prorate)
    }
    
    public func listAll(filter: [String : Any]? = nil) throws -> Future<StripeSubscriptionsList> {
        return try listAll(filter: filter)
    }
    
    public func deleteDiscount(subscription: String) throws -> Future<StripeDeletedObject> {
        return try deleteDiscount(subscription: subscription)
    }
}

public struct StripeSubscriptionRoutes: SubscriptionRoutes {
    private let request: StripeRequest
    
    init(request: StripeRequest) {
        self.request = request
    }

    /// Create a subscription
    /// [Learn More →](https://stripe.com/docs/api/curl#create_subscription)
    public func create(customer: String,
                       applicationFeePercent: Decimal?,
                       billing: String?,
                       billingCycleAnchor: Date?,
                       cancelAtPeriodEnd: Bool?,
                       coupon: String?,
                       daysUntilDue: Int?,
                       items: [[String : Any]]?,
                       metadata: [String : String]?,
                       prorate: Bool?,
                       taxPercent: Decimal?,
                       trialEnd: Any?,
                       trialFromPlan: Bool?,
                       trialPeriodDays: Int?,
                       off_session: Bool?) throws -> Future<StripeSubscription> {
        var body: [String: Any] = [:]
        
        body["customer"] = customer
        
        if let applicationFeePercent = applicationFeePercent {
            body["application_fee_percent"] = applicationFeePercent
        }
        
        if let billing = billing {
            body["billing"] = billing
        }
        
        if let billingCycleAnchor = billingCycleAnchor {
            body["billing_cycle_anchor"] = Int(billingCycleAnchor.timeIntervalSince1970)
        }
        
        if let cancelAtPeriodEnd = cancelAtPeriodEnd {
            body["cancel_at_period_end"] = cancelAtPeriodEnd
        }
        
        if let coupon = coupon {
            body["coupon"] = coupon
        }
        
        if let daysUntilDue = daysUntilDue {
            body["days_until_due"] = daysUntilDue
        }
        
        if let items = items {
            for (index, item) in items.enumerated() {
                item.forEach { body["items[\(index)][\($0)]"] = $1 }
            }
        }
        
        if let metadata = metadata {
            metadata.forEach { body["metadata[\($0)]"] = $1 }
        }
        
        if let prorate = prorate {
            body["prorate"] = prorate
        }
        
        if let taxPercent = taxPercent {
            body["tax_percent"] = taxPercent
        }
        
        if let trialEnd = trialEnd as? Date {
            body["trial_end"] = Int(trialEnd.timeIntervalSince1970)
        }
        
        if let trialEnd = trialEnd as? String {
            body["trial_end"] = trialEnd
        }
        
        if let trialFromPlan = trialFromPlan {
            body["trial_from_plan"] = trialFromPlan
        }
        
        if let trialPeriodDays = trialPeriodDays {
            body["trial_period_days"] = trialPeriodDays
        }
        
        if let off_session = off_session {
            body["off_session"] = off_session
        }
        
        return try request.send(method: .POST, path: StripeAPIEndpoint.subscription.endpoint, body: body.queryParameters)
    }
    
    /// Retrieve a subscription
    /// [Learn More →](https://stripe.com/docs/api/curl#retrieve_subscription)
    public func retrieve(id: String) throws -> Future<StripeSubscription> {
        return try request.send(method: .GET, path: StripeAPIEndpoint.subscriptions(id).endpoint)
    }
    
    /// Update a subscription
    /// [Learn More →](https://stripe.com/docs/api/curl#update_subscription)
    public func update(subscription: String,
                       applicationFeePercent: Decimal?,
                       billing: String?,
                       billingCycleAnchor: String?,
                       cancelAtPeriodEnd: Bool?,
                       coupon: String?,
                       daysUntilDue: Int?,
                       items: [[String : Any]]?,
                       metadata: [String : String]?,
                       prorate: Bool?,
                       prorationDate: Date?,
                       taxPercent: Decimal?,
                       trialEnd: Any?,
                       trialFromPlan: Bool?) throws -> Future<StripeSubscription> {
        var body: [String: Any] = [:]
        
        if let applicationFeePercent = applicationFeePercent {
            body["application_fee_percent"] = applicationFeePercent
        }
        
        if let billing = billing {
            body["billing"] = billing
        }
        
        if let billingCycleAnchor = billingCycleAnchor {
            body["billing_cycle_anchor"] = billingCycleAnchor
        }
        
        if let cancelAtPeriodEnd = cancelAtPeriodEnd {
            body["cancel_at_period_end"] = cancelAtPeriodEnd
        }
        
        if let coupon = coupon {
            body["coupon"] = coupon
        }
        
        if let daysUntilDue = daysUntilDue {
            body["days_until_due"] = daysUntilDue
        }
        
        if let items = items {
            for (index, item) in items.enumerated() {
                item.forEach { body["items[\(index)][\($0)]"] = $1 }
            }
        }
        
        if let metadata = metadata {
            metadata.forEach { body["metadata[\($0)]"] = $1 }
        }
        
        if let prorate = prorate {
            body["prorate"] = prorate
        }
        
        if let prorationDate = prorationDate {
            body["proration_date"] = Int(prorationDate.timeIntervalSince1970)
        }
        
        if let taxPercent = taxPercent {
            body["tax_percent"] = taxPercent
        }
        
        if let trialEnd = trialEnd as? Date {
            body["trial_end"] = Int(trialEnd.timeIntervalSince1970)
        }
        
        if let trialEnd = trialEnd as? String {
            body["trial_end"] = trialEnd
        }
        
        if let trialFromPlan = trialFromPlan {
            body["trial_from_plan"] = trialFromPlan
        }

        return try request.send(method: .POST, path: StripeAPIEndpoint.subscriptions(subscription).endpoint, body: body.queryParameters)
    }
    
    /// Cancel a subscription
    /// [Learn More →](https://stripe.com/docs/api/curl#cancel_subscription)
    public func cancel(subscription: String, invoiceNow: Bool?, prorate: Bool?) throws -> Future<StripeSubscription> {
        var body: [String: Any] = [:]
        
        if let invoiceNow = invoiceNow {
            body["invoice_now"] = invoiceNow
        }
        
        if let prorate = prorate {
            body["prorate"] = prorate
        }
        
        return try request.send(method: .DELETE, path: StripeAPIEndpoint.subscriptions(subscription).endpoint, body: body.queryParameters)
    }
    
    @available(*, deprecated, message: "Use update(subscription:cancelAtPeriodEnd:) instead")
    public func cancel(subscription: String, atPeriodEnd: Bool) throws -> Future<StripeSubscription> {
        let body = ["at_period_end": atPeriodEnd]
        return try request.send(method: .DELETE, path: StripeAPIEndpoint.subscriptions(subscription).endpoint, body: body.queryParameters)
    }
    
    /// List subscriptions
    /// [Learn More →](https://stripe.com/docs/api/curl#list_subscriptions)
    public func listAll(filter: [String : Any]?) throws -> Future<StripeSubscriptionsList> {
        var queryParams = ""
        if let filter = filter {
            queryParams = filter.queryParameters
        }
        
        return try request.send(method: .GET, path: StripeAPIEndpoint.subscription.endpoint, query: queryParams)
    }
    
    /// Delete a subscription discount
    /// [Learn More →](https://stripe.com/docs/api/curl#delete_subscription_discount)
    public func deleteDiscount(subscription: String) throws -> Future<StripeDeletedObject> {
        return try request.send(method: .DELETE, path: StripeAPIEndpoint.subscriptionDiscount(subscription).endpoint)
    }
}
