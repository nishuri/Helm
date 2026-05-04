package terraform.output

import data.terraform.changecontrol
import data.terraform.scoring
import data.terraform.signals.summary

result := {
  "change_type": changecontrol.change_type,
  "risk_score": scoring.risk_score,
  "signals": summary.signals
}
