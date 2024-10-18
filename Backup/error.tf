  custom_rule {
    action                         = "Allow"
    enabled                        = true
    name                           = "Detectifybypass"
    priority                       = 1200
    rate_limit_duration_in_minutes = 1
    rate_limit_threshold           = 100
    type                           = "MatchRule"
    match_condition {
      match_values = [
        "52.17.9.21",
        "52.17.98.13",
        "107.20.158.220",
        "3.234.180.95",
        "34.234.177.119",
        "13.126.5.12",
        "3.7.157.159",
        "3.7.173.162",
        
      ]
      match_variable     = "RemoteAddr"
      negation_condition = false
      operator           = "IPMatch"
      transforms         = []
    }
  }