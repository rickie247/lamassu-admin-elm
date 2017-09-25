module Common.Customer.Decoder exposing (..)

import Json.Decode exposing (..)
import Json.Decode.Extra exposing (date, fromResult)
import Json.Decode.Pipeline exposing (decode, required, optional, hardcoded)
import Common.Customer.Types exposing (..)


customersDecoder : Decoder (List Customer)
customersDecoder =
    field "customers" (list customerDecoder)


stringToConfigScope : String -> Decoder Authorized
stringToConfigScope s =
    case s of
        "blocked" ->
            succeed Blocked

        "verified" ->
            succeed Verified

        "automatic" ->
            succeed Automatic

        _ ->
            fail ("No such type " ++ s)


authorizedDecoder : Decoder Authorized
authorizedDecoder =
    string
        |> andThen stringToConfigScope


customerDecoder : Decoder Customer
customerDecoder =
    decode Customer
        |> required "id" string
        |> required "name" (nullable string)
        |> required "phone" (nullable string)
        |> required "phoneAt" (nullable date)
        |> required "created" date
        |> required "status" (nullable string)
        |> required "authorizedOverride" (nullable authorizedDecoder)
        |> required "authorizedAt" (nullable date)