//
//  RightIssueCalculator.swift
//  KalkulatorSaham
//
//  Created by Alfin on 01/04/23.
//


import Foundation
import ComposableArchitecture
import StockCalculator


struct RightIssueCalculator: ReducerProtocol {
    @Dependency(\.stockCalculator) var stockCalculator
    
    struct State: Equatable {
        @BindingState var ticker: String = ""
        @BindingState var cumDatePrice: Double = 0
        @BindingState var lot: Double = 0
        @BindingState var exercisePrice: Double = 0
        @BindingState var oldRatio: Double = 0
        @BindingState var newRatio: Double = 0
        @BindingState var theoreticalPrice: Double = 0
        @BindingState var currentPrice: Double = 0
        var errors: Validator.Errors = [:]

        var rightIssue: RightIssue? = nil
    }
    
    enum Action: Equatable, BindableAction {
        case binding(BindingAction<State>)
        case validate
        case validateField(_ field: String)
        case calculateButtonTapped
        case calculate
    }
    
    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        
        Reduce { state, action in
            
            // Validation Schema
            let validator = Validator.schema([
                ("ticker", state.ticker, rules: [RequiredRule()]),
                ("cumDatePrice", "\(state.cumDatePrice)", rules: [RequiredRule([.notZero])]),
                ("lot", "\(state.lot)", rules: [RequiredRule([.notZero])]),
                ("exercisePrice", "\(state.exercisePrice)", rules: [RequiredRule([.notZero])]),
                ("oldRatio", "\(state.oldRatio)", rules: [RequiredRule([.notZero])]),
                ("newRatio", "\(state.newRatio)", rules: [RequiredRule([.notZero])])
            ], state.errors)

            
            switch action {
            case .validate:
                state.errors = validator.validate()
                return .none
            case let .validateField(field):
                state.errors = validator.validateField(field)
                return .none
                
            case .binding(\.$ticker):
                return .send(.validateField("ticker"))
            case .binding(\.$cumDatePrice):
                return .send(.validateField("cumDatePrice"))
            case .binding(\.$lot):
                return .send(.validateField("lot"))
            case .binding(\.$exercisePrice):
                return .send(.validateField("exercisePrice"))
            case .binding(\.$oldRatio):
                return .send(.validateField("oldRatio"))
            case .binding(\.$newRatio):
                return .send(.validateField("newRatio"))
            case .binding(\.$currentPrice):
                state.rightIssue = self.stockCalculator.calculateRightIssue(
                    ticker: state.ticker,
                    cumDatePrice: state.cumDatePrice,
                    lot: state.lot,
                    exercisePrice: state.exercisePrice,
                    oldRatio: state.oldRatio,
                    newRatio: state.newRatio,
                    currentPrice: state.currentPrice
                )
                state.theoreticalPrice = state.rightIssue!.theoreticalPrice
                
                return .none
                
            case .calculateButtonTapped:
                return .merge(.send(.validate), .send(.calculate))
            case .calculate:
                guard state.errors.isEmpty else { return .none }
                
                state.rightIssue = self.stockCalculator.calculateRightIssue(
                    ticker: state.ticker,
                    cumDatePrice: state.cumDatePrice,
                    lot: state.lot,
                    exercisePrice: state.exercisePrice,
                    oldRatio: state.oldRatio,
                    newRatio: state.newRatio
                )
                state.theoreticalPrice = state.rightIssue!.theoreticalPrice
                state.currentPrice = state.rightIssue!.theoreticalPrice

                return .none
                
            default:
                return .none
            }
        }
    }
}


