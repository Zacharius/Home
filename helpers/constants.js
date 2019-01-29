const Member_Type = {
    Custodian: 0,
    Inhabitant: 1,
    Member: 2,
    Shareholder: 3
};

const Vote_Type = {
    For: 0,
    Against: 1
};

const Proposal_Type = {
    Confirmation: 0
};

const Result= {
    Undecided: 0,
    Affirmed: 1,
    Denied: 2
}
    

module.exports = {
    Member_Type,
    Vote_Type,
    Proposal_Type,
    Result
};
