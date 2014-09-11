module PayrollHelper
  def submit_payroll
    {
      type: 'submit',
      value: (@payroll.new_record? ? 'Create payroll' : 'Update')
    }
  end
end
