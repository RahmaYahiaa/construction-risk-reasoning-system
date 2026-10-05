;;; Data Templates
(deftemplate risk-cause
   (slot code (type STRING))
   (slot description (type STRING))
   (slot stage (type STRING))
   (slot selected (type SYMBOL) (default FALSE))
   (slot status (type SYMBOL) (default unknown)))

(deftemplate risk
   (slot code (type STRING))
   (slot description (type STRING))
   (slot stage (type STRING))
   (slot deduced (type SYMBOL) (default FALSE)))

(deftemplate risk-link
   (slot risk-code (type STRING))
   (slot cause-code (type STRING)))

(deftemplate alarm
   (slot code (type STRING))
   (slot description (type STRING))
   (slot deduced (type SYMBOL) (default FALSE))
   (slot hypothesis (type SYMBOL) (default FALSE)))

(deffacts startup
   (initial-fact))

;;; Facts: Risk Causes
(deffacts risk-causes
   ;; General/System Issues
   (risk-cause (code "C001") (description "Large-scale problems and unclear causal relationships") (stage "planning"))
   (risk-cause (code "C002") (description "Multiple constraint sources (technical, economic, temporal) with no unified framework") (stage "planning"))
   (risk-cause (code "C003") (description "Complex interactions between subproblems in large systems") (stage "execution"))
   (risk-cause (code "C004") (description "Poor documentation of design decisions or lack of change-tracking tools") (stage "planning"))
   (risk-cause (code "C005") (description "Over-reliance on locally optimal solutions instead of global perspectives") (stage "planning"))
   (risk-cause (code "C006") (description "Limited computational tools for qualitative spatial reasoning") (stage "execution"))
   ;; Management or Operational Errors
   (risk-cause (code "2G31") (description "Lack in planning by project manager") (stage "planning"))
   (risk-cause (code "2E31") (description "project manager misguidance") (stage "execution"))
   (risk-cause (code "2H31") (description "Lack in project manager coordination or investigation") (stage "execution"))
   ;; Environmental Factors
   (risk-cause (code "3K01") (description "Complicated laws or those different from Japan's") (stage "planning"))
   (risk-cause (code "3K02") (description "Law or regulation change") (stage "planning"))
   (risk-cause (code "3Q03") (description "Different business practices of customer") (stage "planning"))
   (risk-cause (code "3Q01") (description "Lack in customer or consultant ability") (stage "planning"))
   (risk-cause (code "3Q02") (description "Lack in customer English ability") (stage "planning"))
   ;; Contractual Defects
   (risk-cause (code "1A01") (description "Contractual defect in scope of equipment supply") (stage "planning"))
   (risk-cause (code "1K01") (description "Contractual defect in arbitration or force majeure") (stage "planning"))
   (risk-cause (code "1G05") (description "Contractual defect in time for approval") (stage "planning"))
   (risk-cause (code "1D02") (description "Contractual defect in technical guarantee") (stage "planning"))
   (risk-cause (code "1F01") (description "Contractual defect in material standard") (stage "planning"))
   (risk-cause (code "1J05") (description "Contractual defect in supplier of temporary power source") (stage "planning"))
   ;; New Causes: Design and Supplier Issues
   (risk-cause (code "C007") (description "Inadequate design specifications") (stage "planning"))
   (risk-cause (code "C008") (description "Supplier delay in delivering critical components") (stage "execution"))
   (risk-cause (code "C009") (description "Non-compliance with quality standards") (stage "execution"))
   (risk-cause (code "C010") (description "Miscommunication between design and execution teams") (stage "execution"))
   ;; New Causes: Resource and Testing Issues
   (risk-cause (code "C011") (description "Insufficient skilled labor availability") (stage "execution"))
   (risk-cause (code "C012") (description "Failure in pre-delivery testing procedures") (stage "execution"))
   (risk-cause (code "C013") (description "Unexpected changes in customer requirements") (stage "planning"))
   (risk-cause (code "C014") (description "Inadequate risk assessment during planning") (stage "planning")))

;;; Facts: Risks
(deffacts risks
   ;; Approval Delays
   (risk (code "2103002") (description "Approval delay due to misguiding spare parts amount") (stage "planning"))
   (risk (code "2103011") (description "Civil approval delay due to loading data") (stage "planning"))
   (risk (code "2103003") (description "Consultant's approval delay") (stage "planning"))
   ;; Civil Work Issues
   (risk (code "41030") (description "Civil work delay due to bad negotiation with consultant") (stage "execution"))
   (risk (code "2202013") (description "Additional equipment due to unchecked specifications") (stage "execution"))
   ;; Material and Delivery Issues
   (risk (code "2202012") (description "Spare parts re-order due to number misorder") (stage "execution"))
   (risk (code "6105011") (description "Spare parts air cargo due to incomplete delivery") (stage "execution"))
   (risk (code "2304003") (description "Material re-test due to inspection company") (stage "execution"))
   (risk (code "51051") (description "Sudden material change due to consultant error") (stage "planning"))
   (risk (code "2103007") (description "Material upgrade request for customer's future plan") (stage "planning"))
   ;; Equipment and Installation Issues
   (risk (code "5103013") (description "Pipe foundation change for big equipment carry-in") (stage "execution"))
   ;; Project Acceptance Issues
   (risk (code "RISK3018") (description "Customer's rejection of project acceptance") (stage "execution"))
   ;; New Risks: Design and Supplier Issues
   (risk (code "3101001") (description "Design rework due to incorrect specifications") (stage "planning"))
   (risk (code "4204001") (description "Delayed equipment delivery by supplier") (stage "execution"))
   (risk (code "4204002") (description "Non-compliant materials detected during inspection") (stage "execution"))
   ;; New Risks: Resource and Testing Issues
   (risk (code "5206001") (description "Project delay due to shortage of skilled workers") (stage "execution"))
   (risk (code "6107001") (description "Failure in final system testing") (stage "delivery"))
   (risk (code "6107002") (description "Customer dissatisfaction due to late requirement changes") (stage "planning"))
   (risk (code "3101002") (description "Cost overrun due to inadequate risk planning") (stage "planning")))

;;; Facts: Risk-Cause Mappings
(deffacts risk-links
   ;; Approval Delays
   (risk-link (risk-code "2103002") (cause-code "2E31"))
   (risk-link (risk-code "2103002") (cause-code "3Q01"))
   (risk-link (risk-code "2103011") (cause-code "2G31"))
   (risk-link (risk-code "2103003") (cause-code "3Q01"))
   (risk-link (risk-code "2103003") (cause-code "1G05"))
   ;; Civil Work
   (risk-link (risk-code "41030") (cause-code "3Q03"))
   (risk-link (risk-code "2202013") (cause-code "2G31"))
   (risk-link (risk-code "2202013") (cause-code "C004"))
   ;; Material and Delivery
   (risk-link (risk-code "2202012") (cause-code "2E31"))
   (risk-link (risk-code "6105011") (cause-code "C003"))
   (risk-link (risk-code "2304003") (cause-code "2H31"))
   (risk-link (risk-code "51051") (cause-code "3Q01"))
   (risk-link (risk-code "2103007") (cause-code "3K02"))
   ;; Equipment and Installation
   (risk-link (risk-code "5103013") (cause-code "1A01"))
   (risk-link (risk-code "5103013") (cause-code "C002"))
   ;; Project Acceptance
   (risk-link (risk-code "RISK3018") (cause-code "3Q01"))
   (risk-link (risk-code "RISK3018") (cause-code "1D02"))
   (risk-link (risk-code "RISK3018") (cause-code "C005"))
   ;; New Mappings: Design and Supplier Issues
   (risk-link (risk-code "3101001") (cause-code "C007"))
   (risk-link (risk-code "3101001") (cause-code "C004"))
   (risk-link (risk-code "4204001") (cause-code "C008"))
   (risk-link (risk-code "4204001") (cause-code "2H31"))
   (risk-link (risk-code "4204002") (cause-code "C009"))
   (risk-link (risk-code "4204002") (cause-code "1F01"))
   ;; New Mappings: Resource and Testing Issues
   (risk-link (risk-code "5206001") (cause-code "C011"))
   (risk-link (risk-code "5206001") (cause-code "2G31"))
   (risk-link (risk-code "6107001") (cause-code "C012"))
   (risk-link (risk-code "6107001") (cause-code "3Q01"))
   (risk-link (risk-code "6107002") (cause-code "C013"))
   (risk-link (risk-code "6107002") (cause-code "3Q03"))
   (risk-link (risk-code "3101002") (cause-code "C014"))
   (risk-link (risk-code "3101002") (cause-code "C001")))

(deffunction clear-analysis-state ()
   (do-for-all-facts ((?f risk-cause)) TRUE
      (modify ?f (selected FALSE) (status unknown)))
   (do-for-all-facts ((?f risk)) TRUE (modify ?f (deduced FALSE)))
   (do-for-all-facts ((?f alarm)) TRUE (retract ?f)))

;;; Rules for Forward and Backward Chaining
(defrule start
   (initial-fact)
   =>
   (clear-analysis-state)
   (bind ?valid-mode FALSE)
   (while (not ?valid-mode)
      (printout t "Select reasoning mode (forward/backward): ")
      (bind ?mode (string-to-field (lowcase (readline))))
      (if (or (eq ?mode forward) (eq ?mode backward)) then
         (bind ?valid-mode TRUE)
         (assert (mode ?mode))
      else
         (printout t "Invalid mode. Please enter 'forward' or 'backward'." crlf)))
   (bind ?valid-stage FALSE)
   (while (not ?valid-stage)
      (printout t "Select project stage (planning/execution/delivery/all): ")
      (bind ?stage (lowcase (readline)))
      (if (or (eq ?stage "planning") (eq ?stage "execution") (eq ?stage "delivery") (eq ?stage "all")) then
         (bind ?valid-stage TRUE)
         (assert (selected-stage ?stage))
      else
         (printout t "Invalid stage. Enter planning, execution, delivery, or all." crlf))))

(defrule start-forward
   (mode forward)
   =>
   (printout t "Enter keyword or phrase (e.g., law, customer, project manager): ")
   (bind ?kw (lowcase (readline)))
   (assert (keyword ?kw)))

(defrule find-matching-causes
   (keyword ?kw)
   (selected-stage ?stage)
   (risk-cause (code ?code) (description ?desc&:(str-index ?kw (lowcase ?desc))) (stage ?cause-stage&:(or (eq ?stage "all") (eq ?cause-stage ?stage))) )
   (not (processed-cause ?code))
   =>
   (printout t "Cause matched: [" ?code "] " ?desc crlf)
   (assert (matched-cause ?code)))

(defrule ask-user-to-confirm-cause
   ?f <- (matched-cause ?code)
   ?cause <- (risk-cause (code ?code))
   =>
   (bind ?valid FALSE)
   (while (not ?valid)
      (printout t "Did this cause happen? (yes/no) [" ?code "]: ")
      (bind ?input (readline))
      (bind ?ans (lowcase (str-cat ?input)))
      (bind ?ans (str-cat (sub-string 1 (str-length ?ans) (implode$ (explode$ ?ans)))))
      (if (or (eq ?ans "yes") (eq ?ans "y") (eq ?ans "true") (eq ?ans "t") (eq ?ans "1")) then
         (bind ?valid TRUE)
         (assert (selected-cause ?code))
         (modify ?cause (selected TRUE) (status confirmed)))
      (if (or (eq ?ans "no") (eq ?ans "n") (eq ?ans "false") (eq ?ans "f") (eq ?ans "0")) then
         (bind ?valid TRUE))
      (if (not ?valid) then
         (printout t "Invalid input. Please enter 'yes' or 'no' (e.g., yes, y, no, n, true, false)." crlf)))
   (assert (processed-cause ?code))
   (retract ?f))

(defrule show-risk-alarms
   (mode forward)
   (selected-cause ?c)
   (risk-link (risk-code ?rc) (cause-code ?c))
   ?risk <- (risk (code ?rc) (description ?rd) (deduced FALSE))
   =>
   (printout t ">>> Possible RISK: [" ?rc "] " ?rd crlf)
   (modify ?risk (deduced TRUE))
   (assert (alarm (code ?rc) (description ?rd) (deduced TRUE) (hypothesis FALSE))))

(defrule print-summary-forward
   (declare (salience -10))
   (mode forward)
   (selected-stage ?stage)
   =>
   (printout t crlf "===== Forward Chaining Summary for stage [" ?stage "] =====" crlf)
   (printout t "Deduced risks:" crlf)
   (do-for-all-facts ((?r risk)) (eq ?r:deduced TRUE)
      (printout t "[" ?r:code "] " ?r:description crlf))
   (printout t "Alarm facts:" crlf)
   (do-for-all-facts ((?a alarm)) TRUE
      (printout t "[" ?a:code "] " ?a:description crlf))
   (printout t "===== Analysis Complete =====" crlf))

;;; Rules for Backward Chaining
(defrule clear-facts-backward
   (declare (salience 100))
   (mode backward)
   =>
   (do-for-all-facts ((?f matched-cause)) TRUE
      (retract ?f))
   (do-for-all-facts ((?f selected-cause)) TRUE
      (retract ?f))
   (do-for-all-facts ((?f processed-cause)) TRUE
      (retract ?f)))

(defrule start-backward
   (mode backward)
   (selected-stage ?stage)
   =>
   (printout t crlf "Available Risks for stage [" ?stage "]: " crlf)
   (do-for-all-facts ((?r risk)) (or (eq ?stage "all") (eq ?r:stage ?stage))
      (printout t "[" ?r:code "] " ?r:description crlf))
   (bind ?valid FALSE)
   (while (not ?valid)
      (printout t crlf "Enter risk code to investigate (e.g., 2103002, RISK3018): ")
      (bind ?rc (lowcase (readline)))
      (bind ?risk-code "")
      (do-for-all-facts ((?r risk)) (and (eq (lowcase ?r:code) ?rc) (or (eq ?stage "all") (eq ?r:stage ?stage)))
         (bind ?valid TRUE)
         (bind ?risk-code ?r:code))
      (if ?valid then
         (assert (selected-risk ?risk-code))
      else
         (printout t "Invalid risk code: [" ?rc "]. Please enter a valid code for stage [" ?stage "]." crlf))))

(defrule find-linked-causes
   (selected-risk ?rc)
   (risk-link (risk-code ?rc) (cause-code ?cc))
   (risk-cause (code ?cc) (description ?desc))
   (not (processed-cause ?cc))
   =>
   (printout t "Possible cause: [" ?cc "] " ?desc crlf)
   (assert (matched-cause ?cc)))

(defrule ask-user-to-confirm-cause-backward
   ?f <- (matched-cause ?cc)
   ?cause <- (risk-cause (code ?cc))
   (selected-risk ?rc)
   =>
   (bind ?valid FALSE)
   (while (not ?valid)
      (printout t "Did this cause happen for risk [" ?rc "]? (yes/no) [" ?cc "]: ")
      (bind ?input (readline))
      (bind ?ans (lowcase (str-cat ?input)))
      (bind ?ans (str-cat (sub-string 1 (str-length ?ans) (implode$ (explode$ ?ans)))))
      (if (or (eq ?ans "yes") (eq ?ans "y") (eq ?ans "true") (eq ?ans "t") (eq ?ans "1")) then
         (bind ?valid TRUE)
         (assert (selected-cause ?cc))
         (modify ?cause (selected TRUE) (status confirmed)))
      (if (or (eq ?ans "no") (eq ?ans "n") (eq ?ans "false") (eq ?ans "f") (eq ?ans "0")) then
         (bind ?valid TRUE))
      (if (not ?valid) then
         (printout t "Invalid input. Please enter 'yes' or 'no' (e.g., yes, y, no, n, true, false)." crlf)))
   (assert (processed-cause ?cc))
   (retract ?f))

(defrule confirm-risk-backward
   (selected-cause ?cc)
   (risk-link (risk-code ?rc) (cause-code ?cc))
   ?risk <- (risk (code ?rc) (description ?rd) (deduced FALSE))
   =>
   (printout t ">>> Risk confirmed: [" ?rc "] " ?rd crlf)
   (modify ?risk (deduced TRUE)))

(defrule print-summary-backward
   (declare (salience -20))
   (mode backward)
   (selected-risk ?rc)
   (selected-stage ?stage)
   =>
   (printout t crlf "===== Backward Chaining Summary for stage [" ?stage "] =====" crlf)
   (printout t "Investigated risk: [" ?rc "]" crlf)
   (printout t "You confirmed the following causes for this risk:" crlf)
   (bind ?confirmed-causes 0)
   (do-for-all-facts ((?c risk-cause)) (eq ?c:selected TRUE)
      (printout t "[" ?c:code "] " ?c:description crlf)
      (bind ?confirmed-causes (+ ?confirmed-causes 1)))
   (if (eq ?confirmed-causes 0) then
      (printout t "No causes were confirmed for this risk." crlf))
   (do-for-all-facts ((?r risk)) (eq ?r:deduced TRUE)
      (printout t "Confirmed risk: [" ?r:code "] " ?r:description crlf))
   (printout t "===== Analysis Complete =====" crlf))