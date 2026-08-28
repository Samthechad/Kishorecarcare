import { supabase } from './supabase'
const noClient = () => { throw new Error('Supabase is not configured. Add your URL and anon key to .env first.') }
export async function getData() {
  if (!supabase) return noClient()
  const [{ data: cars, error: carError }, { data: payments, error: paymentError }] = await Promise.all([
    supabase.from('cars').select('*').order('created_at', { ascending: false }),
    supabase.from('payments').select('*').order('payment_date', { ascending: false })
  ])
  if (carError || paymentError) throw new Error('We could not load your data. Please try again.')
  return { cars: cars || [], payments: payments || [] }
}
export async function saveCar(values, id) {
  if (!supabase) return noClient()
  const payload = { ...values, amount: Number(values.amount), service_date: values.service_date || null, phone: values.phone || null, car_model: values.car_model || null, notes: values.notes || null }
  const { error } = id ? await supabase.from('cars').update(payload).eq('id', id) : await supabase.from('cars').insert(payload)
  if (error) throw new Error('Unable to save the car record. Please try again.')
}
export async function removeCar(id) { if (!supabase) return noClient(); const { error } = await supabase.from('cars').delete().eq('id', id); if (error) throw new Error('Unable to delete the car record. Please try again.') }
export async function addPayment(payment) { if (!supabase) return noClient(); const { error } = await supabase.from('payments').insert({ ...payment, amount: Number(payment.amount), payment_date: payment.payment_date || new Date().toISOString() }); if (error) throw new Error('Unable to record the payment. Please try again.') }

