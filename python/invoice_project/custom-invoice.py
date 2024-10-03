import random
import string



class Invoice:

    def __init__(self, customer_name, amount, payment_info):
        self.customer_name = customer_name.upper()
        self.invoice_id = self.generate_custom_id()
        self.amount = amount
        self.payment_info = payment_info
        self.status = "Pending"

    def approver(self):
        self.status = "Approved"
    
    def rejector(self):
        self.status = "Rejected"
    
    def dis_invo_details(self):

        return (f"Task001\n"
                f"Customer Name: {self.customer_name}\n"
                f"Amount: {self.amount}\n"
                f"Payment Info: {self.payment_info}\n"
                f"Status: {self.status}")
    
    def receive_to_system(self, system):

        invoice_details = self.dis_invo_details()
        delivery_message = f"\nTask002 \nDelivering Customer_Invoice({self.invoice_id}) to the system."

        system.receive_invoice(self)
        system_store = system.receive_invoice(self)

        return f"{invoice_details}\n{delivery_message}\n{system_store}"

    def generate_custom_id(self):
        initials = ''.join([char for char in self.customer_name[:4] if char.isalpha()])
        random_digits = ''.join(random.choices(string.ascii_uppercase + string.digits, k=5))
        return f"{initials}{random_digits}"


class System:

    def __init__(self):
        self.invoices = []

    def receive_invoice(self, invoice):
        return(f"\nTask003\nInvoice-ID: {invoice.invoice_id} has been received by the system with status: {invoice.status}.")

    def sort_invoice(self, sorter):
        sorter_invoices = sorter.sort(self.invoices)
        return(sorter_invoices)

class Sorter:

    def sort(self, invoices):
        return sorted(invoices, key=lambda invoice: invoice.customer_name)


system = System()
invoice = Invoice("Rosario Kendanic", 10000, "Credit Card")
invoice.approver()
result = invoice.receive_to_system(system)
print(result)
